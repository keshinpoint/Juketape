class SessionsController < Clearance::SessionsController

  def new
    @user = User.new
  end

  private

  def url_after_create
    artist_dashfolio_path(username: current_user.username)
  end
end
