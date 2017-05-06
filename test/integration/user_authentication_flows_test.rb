require 'test_helper'

class UserAuthenticationFlowsTest < ActionDispatch::IntegrationTest
  setup do
    # monkey patch deliver_later in test.
    class ActionMailer::MessageDelivery
      def deliver_later
        deliver_now
      end
    end

    @user = User.create!(email: "test_user_1@example.com", password: "password", password_confirmation: "password", email_confirmed_at: Time.now)
  end

  test "homepage redirects to signin page" do
    get root_path
    assert_redirected_to sign_in_path
  end

  test "signed in user gets the homepage" do
    get root_path as: @user
    assert_response :success
  end

  test "non email verified users cannot sign in" do
    @user.email_confirmed_at = nil
    @user.save
    post session_path, params: { session: { email: "test_user_1@example.com", password: "password" } }
    assert_response :unauthorized
    assert_select ".alert", "You must confirm your email address."
  end

  test "sign up creates user and sets confirmation token" do
    assert_nil User.find_by(email: "test@example.com")
    post users_path, params: { user: { email: "test@example.com", password: "password", password_confirmation: "password" } }
    user = User.find_by(email: "test@example.com")
    assert user.instance_of? User
    assert_equal false, user.email_confirmation_token.empty?
  end

  test "sign up sends email to user" do
    get sign_up_path
    assert_response :success
    assert ActionMailer::Base.deliveries.empty?

    post users_path, params: { user: { email: "test@example.com", password: "password", password_confirmation: "password" } }
    assert_response :success

    assert_equal false, ActionMailer::Base.deliveries.empty?
    assert_equal "Email confirmation has been sent.", flash[:notice]
  end

  test "my-settings returns the user settings form" do
    get my_settings_path
    assert_response :redirect

    get my_settings_path as: @user
    assert_response :success
    assert_select "h1", "#{@user.email} - Settings"
    assert_select "form.edit_user"
  end

  test "posting to my-settings updates user" do
    assert_nil @user.time_zone

    patch update_settings_path, params: { user: { email: "bad data" } }
    assert_redirected_to sign_in_path

    patch update_settings_path(as: @user), params: { user: { time_zone: "Bogota" } }
    assert_redirected_to goals_path(@user)
    assert flash[:notice].include? "Your settings have been saved."

    @user.reload
    assert_equal @user.time_zone, "Bogota"
  end

end
