require 'soundcloud'

class SoundcloudNetwork < ApplicationRecord
  belongs_to :user
  validates :access_token, presence: true
  after_create :fetch_and_update_all_tracks_and_albums

  def load_soundcloud
    sc_client = SoundCloud.new(access_token: access_token)
  end

  def tracks
    all_tracks.select {|track| selected_tracks.include?(track['id'].to_s)}
  end

  def albums
    all_albums.select {|album| selected_albums.include?(album['id'].to_s)}
  end

  private
  def fetch_and_update_all_tracks_and_albums
    self.all_tracks = get_me('tracks')
    self.all_albums = get_me('playlists')
    self.save
  end

  def get_me(type)
    begin
      response = load_soundcloud.get("/me/#{type}")
      content = response.map do |track|
        {
          id: track.id,
          title: track.title,
          url: iframe_url(track.uri, type)
        }
      end
    rescue
      return []
    end
  end

  def iframe_url(url, type)
    if type == 'tracks'
      "https://w.soundcloud.com/player/?url=#{url}&amp;color=0066cc"
    elsif type == 'playlists'
      "https://w.soundcloud.com/player/?url=#{url}&auto_play=false&hide_related=false&show_comments=true&show_user=true&show_reposts=false&visual=true"
    end
  end

  def get_images
    load_instagram.recent_images.map do |image|
      {
        id: image['id'],
        link: image['link'],
        url: image['images']['standard_resolution']['url'],
        user_full_name: image['user']['full_name'],
        user_id: image['user']['id'],
        username: image['user']['username']
      }
    end
  end
end
