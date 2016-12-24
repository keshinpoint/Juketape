class RegistrationsController < Clearance::UsersController

  def create
    @user = User.new(user_params)
    if !valid_invitation_code?
      flash[:notice] = "Please use a valid Invite code."
      render 'sessions/new'
    elsif @user.save
      UserMailer.welcome_email(@user).deliver_now
      sign_in @user
      redirect_back_or url_after_create
    else
      flash[:notice] = @user.errors.full_messages.join(',')
      render 'sessions/new'
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def valid_invitation_code?
    User.exists?(invite_code: params[:invite_code])
  end
end
