module ApplicationHelper

  def get_content_partial
    case params[:content_type]
    when 'instagram_images'
      'image_container'
    when 'soundcloud_tracks'
      'music_container'
    when 'soundcloud_albums'
      'music_container'
    when 'facebook_videos'
      'videos_container'
    when 'youtube_videos'
      'videos_container'
    end
  end

end
