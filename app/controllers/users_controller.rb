class UsersController < Clearance::UsersController
  before_action :require_login, only: [:edit, :update]

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

  def edit
    @user = current_user
    render "settings"
  end

  def update
    if current_user.update_attributes(user_params)
      flash.notice = "Your settings have been saved."
      redirect_to goals_path(current_user)
    else
      @errors = current_user.errors.full_messages
      render "settings"
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :time_zone)
  end
end
