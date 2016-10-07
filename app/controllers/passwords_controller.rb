class PasswordsController < ApplicationController
  skip_before_action :require_login
  before_action :get_user, only: [:edit, :update]

  def new
  end

  def create
    if user = User.find_by_normalized_email(params.require(:email))
      user.forgot_password!
      deliver_email(user)
      flash[:notice] = 'You will receive an email within the next few minutes. It contains instructions for changing your password'
    else
      flash[:notice] = 'Email did not find with us'
    end
    if current_user.present?
      redirect_to settings_path
    else
      redirect_to root_path
    end
  end

  def edit
    unless @user.present?
      flash[:notice] = 'Confirmation Token is not valid.'
      redirect_to root_path
    end
  end

  def update
    if (params[:new_password] == params[:confirm_password]) && @user.update_password(params[:new_password])
      if current_user.present?
        flash[:notice] = 'Password reset successfully'
        redirect_to settings_path
      else
        sign_in @user
        redirect_to root_path
      end
    else
      flash[:notice] = 'Token is not valid'
      redirect_to root_path
    end
  end

  private
  def deliver_email(user)
    mail = UserMailer.change_password(user)
    mail.deliver
  end

  def get_user
    @user ||= User.find_by_id_and_confirmation_token(params.require(:id), params.require(:token).to_s)
  end
end
