require 'soundcloud'

class SoundcloudNetwork < ApplicationRecord
  belongs_to :user
  validates :access_token, presence: true

  def load_soundcloud
    sc_client = SoundCloud.new(access_token: access_token)
  end

  def track_widgets
    get_me('tracks').map do |track|
      "https://w.soundcloud.com/player/?url=#{track[:uri]}&amp;color=0066cc"
    end
  end

  def playlist_widgets
    get_me('playlists').map do |playlist|
      "https://w.soundcloud.com/player/?url=#{playlist[:uri]}&auto_play=false&hide_related=false&show_comments=true&show_user=true&show_reposts=false&visual=true"
    end
  end

  private

  def get_me(type)
    begin
      response = load_soundcloud.get("/me/#{type}")
      response.map do |track|
        {
          id: track.id,
          title: track.title,
          uri: track.uri
        }
      end
    rescue
      return []
    end
  end
end
