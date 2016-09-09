class ApplicationController < ActionController::Base
  include Clearance::Controller
  protect_from_forgery with: :exception

  before_action :require_login
  helper_method :soundcloud_oauth

  def authenticate(params)
    User.authenticate(
      params[:session][:username],
      params[:session][:password]
    )
  end

  def soundcloud_oauth
    @sc_oauth ||= SoundCloud.new({
      client_id: ENV['SC_CLIENT_ID'],
      client_secret: ENV['SC_SECRET'],
      redirect_uri: authorize_soundcloud_url()
    })
  end

  private
  def enforce_artist_setup
    redirect_to act_name_setup_index_path() if
      signed_in? && !current_user.finalized_setup?
  end

end
