class UserMailer < ApplicationMailer
  def welcome(user)
    @user = user
    mail(to: @user.email, subject: 'New User Account Created')
  end

  def reset_password_link(user)
    @user = user
    mail(to: @user.email, subject: 'Password Reset Link')
  end

  def password_changed(user)
    mail(to: user.email, subject: 'Your Password Has Been Changed')
  end
end
