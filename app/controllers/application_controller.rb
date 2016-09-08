class ApplicationController < ActionController::Base
  include Clearance::Controller
  protect_from_forgery with: :exception

  before_action :require_login

  def authenticate(params)
    User.authenticate(
      params[:session][:username],
      params[:session][:password]
    )
  end

  private
  def enforce_artist_setup
    redirect_to act_name_setup_index_path() if
      signed_in? && !current_user.finalized_setup?
  end

end
