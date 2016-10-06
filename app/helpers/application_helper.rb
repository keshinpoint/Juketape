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

  def can_connect_with?(current_user, artist)
    if current_user.nil? || (current_user == artist) || current_user.is_connected_to?(artist) || current_user.already_invited?(artist)
      false
    else
      true
    end
  end

  def unable_send_message_tooltip(current_user, artist)
    return 'Please Login to send messages' if current_user.nil?
    if current_user != artist && !current_user.is_connected_to?(artist)
      return 'The user needs to be in your network to send messages'
    end


  end

  def unable_connect_tooltip(current_user, artist)
    return 'Please Login to connect' if current_user.nil?
    return 'You have already connected with this user' if current_user.is_connected_to?(artist)
    return 'You cannot connect with yourself' if current_user == artist
    return 'You have a pending connection request' if current_user.already_invited?(artist)
  end

  def get_unseen_klass(current_user, message)
    return 'unseen' if message.sender != current_user && !message.seen?
  end

  def my_dashfolio_class
    return 'my_dashfolio' if @artist.present? && current_user == @artist
  end

  def error_content
    content_tag :ul do 
      current_user.errors.full_messages.collect { |message| content_tag(:li, message) }.join('').html_safe
    end
  end

end
