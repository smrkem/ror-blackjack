class UsersController < Clearance::UsersController
  def create
    @user = user_from_params
    @user.email_confirmation_token = Clearance::Token.new

    if @user.save
      redirect_back_or url_after_create
    else
      render template: "users/new"
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
