require 'test_helper'

class GoalFlowsTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "index for user shows list of their own goals" do
    get goals_path(as: @user)
    assert_select "li.goal .goal-name", "Test Goal 1"
    assert_select "li.goal", { count: 0, text: goals(:two).name }
  end

  test "can create a goal on the inex page" do
    get goals_path(as: @user)
    assert_select "a[href=?]", new_goal_path, "Add New Goal"

    get new_goal_path(as: @user), xhr: true
    assert_response 200

    post goals_path(as: @user), xhr: true,
      params: { goal: { name: "some goal", frequency: 1, description: "test goal description" } }
    assert_response :success

    assert @user.goals.pluck(:name).include?("some goal")
  end
end
