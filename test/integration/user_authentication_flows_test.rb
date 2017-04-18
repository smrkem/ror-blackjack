require 'test_helper'

class UserAuthenticationFlowsTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(email: "test_user_1@example.com", password: "password", password_confirmation: "password")
  end

  test "homepage redirects to signin page" do
    get root_path
    assert_redirected_to sign_in_path
  end

  test "signed in user gets the homepage" do
    get root_path as: @user
    assert_response :success
  end

  test "sign up" do
    get sign_up_path
    assert_response :success

    post users_path, params: { user: { email: "test@example.com", password: "password", password_confirmation: "password" } }
    assert_response :redirect
    follow_redirect!
    assert_select "p", "test@example.com"

  end

end
