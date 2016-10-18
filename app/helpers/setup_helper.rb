module SetupHelper

  def soundcloud_oauth_url
    soundcloud_oauth.authorize_url(scope: 'non-expiring')
  end

  def connect_soundcloud_text
    if current_user.soundcloud_network.present?
      "<span class='fa fa-soundcloud'></span>Connected SoundCloud as #{current_user.soundcloud_network.display_name}".html_safe
    else
      "<span class='fa fa-soundcloud'></span>Connect SoundCloud".html_safe
    end
  end

  def connect_soundcloud_link
    if current_user.soundcloud_network.present?
      'javascript:void(0);'
    else
      soundcloud_oauth_url
    end
  end

  def youtube_oauth_url
    youtube_oauth.authentication_url
  end

  def connect_youtube_text
    if current_user.youtube_network.present?
      "<span class='fa fa-youtube-play'></span>Connected Youtube".html_safe
    else
      "<span class='fa fa-youtube-play'></span>Connect YouTube".html_safe
    end
  end

  def connect_youtube_link
    if current_user.youtube_network.present?
      'javascript:void(0);'
    else
      youtube_oauth_url
    end
  end

  def facebook_oauth_url
    fb_url = facebook_oauth.url_for_oauth_code(permissions: FACEBOOK_PERMISSIONS.join(','))
  end

  def connect_facebook_text
    if current_user.facebook_network.present?
      "<span class='fa fa-facebook'></span>Connected Facebook as #{current_user.facebook_network.display_name}".html_safe
    else
      "<span class='fa fa-facebook'></span>Connect Facebook".html_safe
    end
  end

  def connect_facebook_link
    if current_user.facebook_network.present?
      'javascript:void(0);'
    else
      facebook_oauth_url
    end
  end

  def instagram_oauth_url
    instagram_oauth.oauth_url(scope: INSTAGRAM_SCOPE.join('+'))
  end

  def connect_instagram_text
    if current_user.instagram_network.present?
      "<span class='fa fa-instagram'></span>Connected Instagram as #{current_user.instagram_network.display_name}".html_safe
    else
      "<span class='fa fa-instagram'></span>Connect Instagram".html_safe
    end
  end

  def connect_instagram_link
    if current_user.instagram_network.present?
      'javascript:void(0);'
    else
      instagram_oauth_url
    end
  end
end
