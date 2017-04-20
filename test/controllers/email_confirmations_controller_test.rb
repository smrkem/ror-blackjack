require 'test_helper'

class EmailConfirmationsControllerTest < ActionDispatch::IntegrationTest
  test "should get error page with invalid token" do
    assert_raises ActiveRecord::RecordNotFound do
      get confirm_email_path token: "invalid"
    end
  end

  test "user gets confirmed and redirected with valid token" do
    user = User.create(email: "test@example.com", password: "password", password_confirmation: "password", email_confirmation_token: "valid_token")
    get confirm_email_path token: "valid_token"

    assert_response :redirect
    user.reload
    assert_equal false, user.email_confirmed_at.nil?
  end
end
