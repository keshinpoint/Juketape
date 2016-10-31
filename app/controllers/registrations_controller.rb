class RegistrationsController < Clearance::UsersController

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      redirect_back_or url_after_create
    else
      flash[:notice] = @user.errors.full_messages.join(',')
      render 'sessions/new'
    end

    respond_to do |format|
         if @user.save
            # Tell the UserMailer to send a welcome email after save
            UserMailer.welcome_email(@user).deliver_now
            
            
            
         
            
            
         end
         
      end

  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end
end
