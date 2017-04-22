require 'test_helper'

class GoalActivityTest < ActiveSupport::TestCase
  setup do
    @goal_activity = goal_activities(:one)
  end

  test "should be invalid without a goal" do
    @goal_activity.goal = nil
    assert_not @goal_activity.valid?
    assert @goal_activity.errors.full_messages.include?("Goal must exist")
  end

  test "should be invalid without performed_at in the past" do
    @goal_activity.performed_at = nil
    assert_not @goal_activity.valid?
    assert @goal_activity.errors.full_messages.include?("Performed at can't be blank")

    @goal_activity.performed_at = 3.hours.from_now
    assert_not @goal_activity.valid?
    assert @goal_activity.errors.full_messages.include?("Performed at can't be in the future")
  end
end
