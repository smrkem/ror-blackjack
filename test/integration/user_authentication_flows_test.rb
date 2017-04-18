require 'test_helper'

class UserAuthenticationFlowsTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(email: "test_user_1@example.com", password: "password", password_confirmation: "password")
  end

  test "homepage redirects to signin page" do
    get root_path
    assert_redirected_to sign_in_path
  end

end
