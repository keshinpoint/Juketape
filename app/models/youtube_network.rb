class YoutubeNetwork < ApplicationRecord

  belongs_to :user
  validates :access_token, :refresh_token, :expires_in, presence: true

  def load_youtube
    @client ||= Yt::Account.new(access_token: get_new_access_token)
  end

  def revoke_access
    begin
      load_youtube.revoke_access
    rescue
    end
  end

  def get_new_access_token
    data = {
      client_id: ENV['YT_CLIENT_ID'],
      client_secret: ENV['YT_CLIENT_SECRET'],
      refresh_token: refresh_token,
      grant_type: 'refresh_token'
    }

    result = YoutubeNetwork.conn.post '/o/oauth2/token', data
    result_body = JSON.parse(result.body)
    result_body['access_token']
  end

  def self.conn
    conn = Faraday.new(:url => 'https://accounts.google.com',:ssl => {:verify => false}) do |faraday|
      faraday.request  :url_encoded
      faraday.response :logger
      faraday.adapter  Faraday.default_adapter
    end
  end

  def videos
    begin
      channel_vidoes = load_youtube.videos
      channel_vidoes.map do |video|
        {
          id: video.id,
          title: video.title,
          embeded_url: "https://www.youtube.com/embed/#{video.id}?rel=0"
        }
      end
    rescue
      return []
    end
  end
end
