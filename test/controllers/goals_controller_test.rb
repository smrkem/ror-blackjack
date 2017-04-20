require 'test_helper'

class GoalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "should get index when logged in" do
    get goals_path(as: @user)
    assert_response :success
  end

  test "index should redirect when not logged in" do
    get goals_path
    assert_redirected_to sign_in_path
  end

end
