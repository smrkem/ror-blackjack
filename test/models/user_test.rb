require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "confirm sets email_confirmed_at" do
    user = User.create(email: "test@example.com", password: "password", password_confirmation: "password", email_confirmation_token: "valid_token")
    assert_nil user.email_confirmed_at

    user.confirm_email
    user.reload

    assert_equal false, user.email_confirmed_at.nil?
  end
end
