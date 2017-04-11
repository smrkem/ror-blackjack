require 'test_helper'

class HealthStatusTest < ActiveSupport::TestCase
  setup do
    @health_status = health_statuses(:one)
    @health_status.user = User.create!(email: "test_user_1@example.com", password: "password", password_confirmation: "password")
  end

  test "should be invalid without mindfulness" do
    @health_status.mindfulness = nil
    assert_not @health_status.valid?
  end

  test "should be invalid without physically_active" do
    @health_status.physically_active = nil
    assert_not @health_status.valid?
  end

  test "should be invalid without happiness" do
    @health_status.happiness = nil
    assert_not @health_status.valid?
  end

  test "should be invalid without diet" do
    @health_status.diet = nil
    assert_not @health_status.valid?
  end

  test "should be invalid without mentally_active" do
    @health_status.mentally_active = nil
    assert_not @health_status.valid?
  end

  test "should be invalid without socially_active" do
    @health_status.socially_active = nil
    assert_not @health_status.valid?
  end

  test "should be invalid without a user" do
    @health_status.user = nil
    assert_not @health_status.valid?
  end
end
