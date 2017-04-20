require 'test_helper'

# monkey patch deliver_later in test.
class ActionMailer::MessageDelivery
  def deliver_later
    deliver_now
  end
end

class UserAuthenticationFlowsTest < ActionDispatch::IntegrationTest
  setup do
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
    assert_response :redirect

    assert_equal false, ActionMailer::Base.deliveries.empty?
    assert_equal "Email confirmation has been sent.", flash[:notice]
  end

end
