class UserMailer < ApplicationMailer

  def change_password(user)
    @user = user
    mail(subject: 'Forget your password?', to: @user.email)
  end

  def welcome_email(user)
    @user = user
    mail(subject: 'Welcome to Juketape!', to: @user.email)
  end

end