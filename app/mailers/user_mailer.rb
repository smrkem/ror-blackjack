class UserMailer < ApplicationMailer
  def registration_confirmation(user)
    @user = user
    mail(to: @user.email, subject: 'Please verify your email address on TrackMe')
  end
end
