require 'test_helper'

class GoalActivityFlowsTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @goal = goals(:one)
    @goal_activity = goal_activities(:one)
  end

  test "can add a previous goal completion from the goal page" do
    get goal_path(@goal, as: @user)
    assert_response :success
    assert_select "a[href=?]", new_goal_goal_activity_path(@goal), "Add Previous Goal Activity"

    get new_goal_goal_activity_path(@goal, as: @user), xhr: true
    assert_response 200

    post goal_goal_activities_path(@goal, as: @user), params: { goal_activity: { performed_at: 3.days.ago } }, xhr: true
    assert_response 200
  end

  test "can delete a goal activity from the goal page" do
    get goal_path(@goal, as: @user)
    assert_select "a[href=?][data-method=\"delete\"]", goal_goal_activity_path(@goal, @goal_activity), "Delete This Activity"

    delete goal_goal_activity_path(@goal, @goal_activity), as: @user, xhr: true
    assert_response 200

    assert @goal.goal_activities.count, 0
  end

  test "can add a goal completion from the index page" do
    assert_equal @goal.goal_activities.count, 1
    get goals_path(as: @user)
    assert_select "#goal_#{@goal.id} .complete_now_button"

    post complete_now_goal_path(@goal, as: @user), params: { msg: "complete" }, xhr: true
    assert_response :success

    assert_equal @goal.goal_activities.count, 2
  end
end
