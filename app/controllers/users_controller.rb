class UsersController < Clearance::UsersController
  def create
    @user = user_from_params
    @user.email_confirmation_token = Clearance::Token.new

    if @user.save
      UserMailer.registration_confirmation(@user).deliver_later
      flash.now.notice = "Email confirmation has been sent."
      render template: "users/confirmation_email_sent"
    else
      render template: "users/new"
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
