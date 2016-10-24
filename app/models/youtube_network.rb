class YoutubeNetwork < ApplicationRecord

  belongs_to :user
  validates :access_token, :refresh_token, :expires_in, presence: true
  after_create :fetch_and_update_all_videos

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
    return all_videos if sync_always?
    all_videos.select {|image| selected_videos.include?(image['id'])}
  end

  def selected_video_ids
    return selected_videos unless sync_always?
    all_videos.map { |i| i['id'].to_s }
  end

  def self.sync_data
    puts "***** Syncing data for Youtube on #{Date.current} *****"
    all.each do |network|
      network.send(:fetch_and_update_all_videos)
    end
    puts '***** Done for Youtube *****'
  end

  private
  def fetch_and_update_all_videos
    self.update_attributes(all_videos: get_videos)
  end

  def get_videos
    begin
      channel_vidoes = load_youtube.videos
      channel_vidoes.map do |video|
        {
          id: video.id,
          title: video.title,
          url: "https://www.youtube.com/embed/#{video.id}?rel=0"
        }
      end
    rescue
      return []
    end
  end
end
