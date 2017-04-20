require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  setup do
    @user = User.create!(email: "test_user_1@example.com", password: "password", password_confirmation: "password", email_confirmation_token: 'secret_token')
  end

  test "registration_confirmation" do
    email = UserMailer.registration_confirmation(@user)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ['no-reply@mattsmrke.me'], email.from
    assert_equal [@user.email], email.to
    assert_equal 'Please verify your email address on TrackMe', email.subject
  end
end
