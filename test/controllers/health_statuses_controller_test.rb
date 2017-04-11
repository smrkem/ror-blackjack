require 'test_helper'

class HealthStatusesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(email: "test_user_1@example.com", password: "password", password_confirmation: "password")
    @health_status = health_statuses(:one)
    @health_status.user = @user
    @health_status.save
  end

  test "should get index when logged in" do
    get health_statuses_path(as: @user)
    assert_response :success
  end

  test "index should redirect when not logged in" do
    get health_statuses_path
    assert_redirected_to sign_in_path
  end

  test "should get new when logged in" do
    get new_health_status_path(as: @user)
    assert_response :success
  end

  test "should get edit via ajax when logged in" do
    get edit_health_status_path(@health_status, as: @user), xhr: true
    assert_response :success
  end

  test "edit should return unauthorized when not logged in" do
    get edit_health_status_path(@health_status), xhr: true
    assert_response :unauthorized
  end

end
