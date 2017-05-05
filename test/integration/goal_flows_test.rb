require 'test_helper'

class GoalFlowsTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @goal = goals(:one)
  end

  test "index for user shows list of their own goals" do
    get goals_path(as: @user)
    assert_select "li.goal .goal-name", "Test Goal 1"
    assert_select "li.goal", { count: 0, text: goals(:two).name }
  end


  test "index for user shows finished goals as complete" do
    complete_weekly_goal(@goal)
    get goals_path(as: @user)
    assert_select "li.goal.completed-goal .goal-name", @goal.name

  end

  test "index shows goal completion for the week" do
    @goal.goal_activities.destroy_all
    @goal.goal_activities.create(performed_at: Date.today.beginning_of_week - 1)
    @goal.goal_activities.create(performed_at: Date.today.beginning_of_week)
    @goal.goal_activities.create(performed_at: Date.today.beginning_of_week)

    get goals_path(as: @user)
    assert_select "li#goal_#{@goal.id} .completion_count", "2/5"
  end

  test "can create a goal on the index page" do
    get goals_path(as: @user)
    assert_select "a[href=?]", new_goal_path, "Add New Goal"

    get new_goal_path(as: @user), xhr: true
    assert_response 200

    post goals_path(as: @user), xhr: true,
      params: { goal: { name: "some goal", frequency: 1, description: "test goal description" } }
    assert_response :success

    assert @user.goals.pluck(:name).include?("some goal")
  end

  test "can delete a goal from the show page" do
    assert_equal @user.goals.count, 1
    get goal_path(@goal, as: @user)
    assert_response :success
    assert_select "a[href=?][data-method=\"delete\"]", goal_path(@goal), "Delete Goal"

    delete goal_path(@goal, as: @user)

    assert_redirected_to goals_path
    follow_redirect!
    assert_select ".alert", "#{@goal.name} has been removed."
    assert_equal @user.goals.count, 0
  end
end
