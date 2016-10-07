class UserMailer < ApplicationMailer

  def change_password(user)
    @user = user
    mail(subject: 'Forget your password?', to: @user.email)
  end
end