require 'test_helper'

class GoalTest < ActiveSupport::TestCase
  setup do
    @goal = goals(:one)
  end

  test "should be invalid without name" do
    @goal.name = nil

    assert_not @goal.valid?
    assert_equal true, @goal.errors.full_messages.include?("Name can't be blank")
  end

  test "name should be unique for same user" do
    new_goal = Goal.new(name: @goal.name, user: @goal.user, frequency: 2)
    assert_not new_goal.valid?
    assert_equal true, new_goal.errors.full_messages.include?("Name has already been taken")
  end

  test "different users can use the same goal name" do
    new_goal = goals(:two)
    new_goal.name = @goal.name
    assert new_goal.valid?
  end

  test "frequency must be integer between 1 and 100" do
    @goal.frequency = 'a'
    assert_not @goal.valid?
    assert_equal true, @goal.errors.full_messages.include?("Frequency is not a number")

    @goal.frequency = 0
    assert_not @goal.valid?
    assert_equal true, @goal.errors.full_messages.include?("Frequency must be greater than or equal to 1")

    @goal.frequency = 101
    assert_not @goal.valid?
    assert_equal true, @goal.errors.full_messages.include?("Frequency must be less than or equal to 100")
  end

  test "can get completions for the current week" do
    @goal.goal_activities.destroy_all
    @goal.goal_activities.create(performed_at: Date.today.beginning_of_week - 1)
    @goal.goal_activities.create(performed_at: Date.today.beginning_of_week)
    @goal.goal_activities.create(performed_at: Date.today.beginning_of_week)

    assert_equal @goal.completions, 2
  end
end
