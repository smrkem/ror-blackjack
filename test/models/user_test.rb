require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    @goal = goals(:one)
  end
  test "confirm sets email_confirmed_at" do
    user = User.create(email: "test@example.com", password: "password", password_confirmation: "password", email_confirmation_token: "valid_token")
    assert_nil user.email_confirmed_at

    user.confirm_email
    user.reload

    assert_equal false, user.email_confirmed_at.nil?
  end

  test "active_goals returns all goals with deleted_at nil" do
    assert_equal @user.active_goals.count, 1
    @goal.update_attributes({ deleted_at: Time.current })

    assert_equal @user.active_goals.count, 0
  end

  test "inactive_goals returns all goals with deleted_at nil" do
    assert_equal @user.inactive_goals.count, 0
    @goal.update_attributes({ deleted_at: Time.current })

    assert_equal @user.inactive_goals.count, 1
  end
end
