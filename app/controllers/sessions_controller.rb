class SessionsController < Clearance::SessionsController

  def new
    @user = User.new
  end

end
