require 'soundcloud'

class SoundcloudNetwork < ApplicationRecord
  belongs_to :user
  validates :access_token, presence: true

  def load_soundcloud
    sc_client = SoundCloud.new(access_token: access_token)
  end

  def all_tracks
    @tracks ||= tracks
  end

  def user_tracks
    return all_tracks if selected_items.blank?
    all_tracks.select { |x| selected_items.include?(x[:id].to_s) }
  end

  def profile
    @data ||= load_soundcloud.get('/me')
    {
      followers_count: @data.followers_count,
      followings_count: @data.followings_count,
      tracks_count: user_tracks.count
    }
  end

  private

  def tracks
    begin
      response = load_soundcloud.get('/me/tracks')
      response.map do |track|
        {
          id: track.id,
          title: track.title,
          permalink: track.permalink,
          permalink_url: track.permalink_url,
          artist_permalink: track.user.permalink,
          artist_permalink_url: track.user.permalink_url,
          sharing: track.sharing,
          description: track.description,
          duration: track.duration,
          genre: track.genre,
          stream_url: track.stream_url,
          artwork_url: track.artwork_url,
          waveform_url: track.waveform_url,
          playback_count: track.playback_count,
          created_at: track.created_at,
          favoritings_count: track.favoritings_count,
          artwork: track.artwork_url || track.user.avatar_url
        }
      end
    rescue
      return []
    end
  end
end
