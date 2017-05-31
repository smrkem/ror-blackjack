require 'test_helper'

class GoalFlowsTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @goal = goals(:one)
  end

  test "index shows list of user's own goals" do
    get goals_path(as: @user)

    assert_select "li.goal .goal-name", {count: 1, text: "Test Goal 1" }
    assert_select "li.goal .goal-name", {count: 0, text: goals(:two).name }
  end

  test "index only shows active goals" do
    @goal.update_attributes({ deleted_at: Time.current })
    get goals_path(as: @user)

    assert_select "li.goal .goal-name", { count: 0, text: @goal.name }
  end

  test "index links to user's deactivated goals" do
    get goals_path(as: @user)
    assert_select "a[href=?]", previous_goals_path, "Previous Goals"

    @goal.update_attributes({ deleted_at: Time.current })
    get previous_goals_path(as: @user)
    assert_response :success

    assert_select "li.previous_goal .goal-name", @goal.name
  end

  test "index shows finished goals as complete" do
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
    assert_equal @user.active_goals.count, 1
    get goal_path(@goal, as: @user)
    assert_response :success
    assert_select "a[href=?]", deactivate_goal_path(@goal), "Delete Goal"

    get deactivate_goal_path(@goal), as: @user
    assert_redirected_to goals_path
    follow_redirect!

    assert_select "li#goal_#{@goal.id}", false
    assert_select ".alert", "#{@goal.name} has been removed."
    assert_equal @user.active_goals.count, 0
  end

  test "can edit a goal from the show page" do
    get goal_path(@goal, as: @user)
    assert_select "a[href=?][data-remote=\"true\"]", edit_goal_path(@goal), "Edit Goal"

    get edit_goal_path(@goal, as: @user), xhr: true
    assert_response :success
    assert_equal "text/javascript", @response.content_type

    patch goal_path(@goal, as: @user), xhr: true,
      params: { goal: { name: "edited goal", frequency: 4, description: "edited goal description" } }
    assert_response :success
    assert_equal "text/javascript", @response.content_type

    @goal.reload
    assert_equal "edited goal", @goal.name
  end

  test "can permanently delete a goal from previous goals page" do
    total_goals = @user.goals.count
    @goal.update_attributes({ deleted_at: Time.current })
    get previous_goals_path(as: @user)

    assert_select "a[href=?][data-method=\"delete\"]", goal_path(@goal), "Permanently Delete Goal"

    delete goal_path(@goal)
    assert_redirected_to previous_goals_path

    assert_equal @user.goals.count, total_goals - 1
  end

  test "can reactivate a goal from previous goals page" do
    @goal.update_attributes({ deleted_at: Time.current })
    assert_equal 1, @user.inactive_goals.count
    get previous_goals_path(as: @user)

    assert_select "#goal_#{@goal.id} button.reactivate_goal_button", "Reactivate Goal"

    assert_equal 0, @user.inactive_goals.count
  end

end
