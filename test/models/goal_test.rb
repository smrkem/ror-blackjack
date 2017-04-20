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

  test "should be invalid without frequency" do
    @goal.frequency = nil

    assert_not @goal.valid?
    assert_equal true, @goal.errors.full_messages.include?("Frequency can't be blank")
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
end
