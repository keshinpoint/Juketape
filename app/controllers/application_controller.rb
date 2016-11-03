require 'instagram'

class ApplicationController < ActionController::Base
  include Clearance::Controller

  # protect_from_forgery with: :exception
  protect_from_forgery with: :null_session

  before_action :require_login
  helper_method :soundcloud_oauth, :youtube_oauth, :facebook_oauth, :instagram_oauth, :can_connect_with?

  def authenticate(params)
    User.authenticate(
      params[:session][:username],
      params[:session][:password]
    )
  end

  def soundcloud_oauth
    @sc_oauth ||= SoundCloud.new({
      client_id: Rails.application.secrets.sc_client_id,
      client_secret: Rails.application.secrets.sc_secret,
      redirect_uri: authorize_soundcloud_url()
    })
  end

  def youtube_oauth
    @youtube_client = Yt::Account.new(
      scopes: ['youtube'],
      redirect_uri: authorize_youtube_url
    )
  end

  def facebook_oauth
    @oauth ||= Koala::Facebook::OAuth.new(
      Rails.application.secrets.fb_app_id,
      Rails.application.secrets.fb_secret,
      authorize_facebook_url()
    )
  end

  def instagram_oauth
    @ig_oauth ||= Instagram.new({
      redirect_uri: authorize_instagram_url()
    })
  end

  def can_connect_with?(current_user, artist)
    if current_user.nil? || (current_user == artist) || current_user.is_connected_to?(artist) || current_user.already_invited?(artist)
      false
    else
      true
    end
  end

  private
  def enforce_artist_setup
    redirect_to act_name_setup_index_path() if
      signed_in? && !current_user.finalized_setup?
  end

end
