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

  def user_videos
    return all_videos if selected_items.blank?
    all_videos.select { |x| selected_items.include?(x[:id].to_s) }
  end

  def all_videos
    @all_videos ||= videos
  end

  def channel_stats
    begin
      channel = load_youtube.channel
      {
        subscribers_count: channel.subscriber_count,
        views_count: channel.view_count,
        videos_count: user_videos.count
      }
    rescue
      return {}
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

  private

  def videos
    begin
      channel_vidoes = load_youtube.videos
      channel_vidoes.map do |video|
        {
          id: video.id,
          title: video.title,
          # likes_count: video.likes.total,
          likes_count: "NA",
          published_at: video.published_at,
          thumbnail_url: video.thumbnail_url,
          watch_url: "https://www.youtube.com/watch?v=#{video.id}",
          duration: video.duration
        }
      end
    rescue
      return []
    end
  end
end
