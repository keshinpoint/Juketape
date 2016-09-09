module SetupHelper

  def soundcloud_oauth_url
    soundcloud_oauth.authorize_url(scope: 'non-expiring')
  end

  def connect_soundcloud_text
    if current_user.soundcloud_network.present?
      "<span class='fa fa-soundcloud'></span>Connected SoundCloud".html_safe
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
end
