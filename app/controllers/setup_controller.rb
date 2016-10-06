class SetupController < ApplicationController

  def act_name
    flash[:notice] = 'Please complete your one time Profile setup wizard configuration'
  end

  def tag_line
    if request.post?
      current_user.update_attributes(user_attrs(:act_name))
      flash[:notice] = 'Act Name updated successfully.'
    end
  end

  def profile_pic
    if request.post?
      current_user.update_attributes(user_attrs(:tag_line))
      flash[:notice] = 'Tagline updated successfully.'
    end
  end

  def social_media
    if request.post?
      current_user.update_attributes(user_attrs(:image))
      flash[:notice] = 'Profile Picture updated successfully.'
    end
  end

  def finalize_setup
    current_user.update_attributes(finalized_setup: true)
    redirect_to dashfolio_artists_path()
  end

  def authorize_soundcloud
    unless params[:error].present?
      token = soundcloud_oauth.exchange_token(code: params[:code])
      network = current_user.create_soundcloud_network(
        access_token: token[:access_token],
        refresh_token: token[:refresh_token]
      )
      flash[:notice] = network.valid? ?
        'Successfully added SoundCloud' :
        'Failed to add SoundCloud'
    else
      flash[:notice] = 'Failed to add SoundCloud as user denied the permission'
    end
    if current_user.finalized_setup?
      redirect_to settings_path()
    else
      redirect_to social_media_setup_index_path
    end
  end

  def authorize_youtube
    result = YoutubeNetwork.conn.post '/o/oauth2/token', {
      code: params[:code],
      client_id: ENV['YT_CLIENT_ID'],
      client_secret: ENV['YT_CLIENT_SECRET'],
      redirect_uri: authorize_youtube_url,
      grant_type: 'authorization_code'
    }
    result_body = JSON.parse(result.body)

    network = current_user.create_youtube_network(
      access_token: result_body['access_token'],
      refresh_token: result_body['refresh_token'],
      expires_in: result_body['expires_in']
    )
    flash[:notice] = network.valid? ?
      'Successfully added Youtube' :
      'Failed to add Youtube'
    if current_user.finalized_setup?
      redirect_to settings_path()
    else
      redirect_to social_media_setup_index_path
    end
  end

  def authorize_facebook
    unless params[:error].present?
      token = facebook_oauth.get_access_token(params[:code])
      network = current_user.create_facebook_network(token: token)
      flash[:notice] = network.valid? ?
        'Successfully added Facebook' :
        'Failed to add Facebook'
    else
      flash[:notice] = 'Failed to add Facebook as user denied the permission'
    end
    if current_user.finalized_setup?
      redirect_to settings_path()
    else
      redirect_to social_media_setup_index_path
    end
  end

  def authorize_instagram
    unless params[:error].present?
      token = instagram_oauth.get_access_token(params[:code])
      network = current_user.create_instagram_network(access_token: token)
      flash[:notice] = network.valid? ?
        'Successfully added Instagram' :
        'Failed to add Instagram'
    else
      flash[:notice] = "Failed to add Instagram as #{params[:error_description]}"
    end
    if current_user.finalized_setup?
      redirect_to settings_path()
    else
      redirect_to social_media_setup_index_path
    end
  end

  private
  def user_attrs(field)
    params.require(:user).permit(field)
  end
end
