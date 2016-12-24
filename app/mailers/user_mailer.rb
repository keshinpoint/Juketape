class UserMailer < ApplicationMailer

  def change_password(user)
    @user = user
    mail(subject: 'Forget your password?', to: @user.email)
  end

  def welcome_email(user)
    @user = user
    mail(subject: 'Welcome to Juketape!', to: @user.email)
  end

  def invitation_email(user, emails)
    @user = user
    mail(subject: 'Invitation Email to Juketape', to: emails)
  end

  def send_requested_invitation(email)
    @email = email
    mail(subject: 'Invite code requested', to: 'keshav@juketape.com')
  end

end