module ApplicationHelper

  def get_content_partial
    case params[:content_type]
    when 'instagram_images'
      'images_container'
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

  def get_tab_content_id
    case params[:content_type]
    when 'instagram_images'
      'pictures-dashfolio'
    when 'soundcloud_tracks'
      'tracks-dashfolio'
    when 'soundcloud_albums'
      'album-dashfolio'
    when 'facebook_videos'
      'videos-dashfolio'
    when 'youtube_videos'
      'videos-dashfolio'
    end
  end

end
