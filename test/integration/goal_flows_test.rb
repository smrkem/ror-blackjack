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
    @goal.update_attributes({ active: false })
    get goals_path(as: @user)

    assert_select "li.goal .goal-name", { count: 0, text: @goal.name }
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

  test "index links to user's deactivated goals" do
    get goals_path(as: @user)
    assert_select "a[href=?]", inactive_goals_path, "Inactive Goals"

    @goal.update_attributes({ active: false })
    get inactive_goals_path(as: @user)
    assert_response :success

    assert_select "li.inactive_goal .goal-name", @goal.name
  end

  test "show page displays correct active_toggle" do
    # when goal is active
    get goal_path(@goal, as: @user)
    assert_select ".goal_active_toggle.toggle_on input"

    # when goal is inactive
    @goal.update_attributes(active: false)
    get goal_path(@goal, as: @user)
    assert_select ".goal_active_toggle.toggle_off input"
  end

  test "can deactivate a goal from the show page" do
    assert_equal 0, @user.goals.inactive.count

    get goal_path(@goal, as: @user)
    assert_select ".goal_active_toggle.toggle_on"

    patch set_active_goal_path(@goal, as: @user, format: :json),
      params: { active: false }
    assert_response :success
    assert_equal "application/json", @response.content_type

    assert_equal 1, @user.goals.inactive.count
  end

  test "can permanently delete a goal from the show page" do
    total_goals = @user.goals.count
    @goal.update_attributes({ active: false })
    get goal_path(@goal, as: @user)

    assert_select "a[href=?][data-method=\"delete\"]", goal_path(@goal), "Permanently Delete Goal"

    delete goal_path(@goal)
    assert_redirected_to goals_path
    follow_redirect!
    assert_select ".alert", "#{@goal.name} has been deleted."

    assert_equal @user.goals.count, total_goals - 1
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

  test "inactive goals link to show page" do
    @goal.update_attributes({ active: false })
    assert_equal 1, @user.goals.inactive.count
    get inactive_goals_path(as: @user)

    assert_select "li#goal_#{@goal.id} a[href=?] .goal-name", goal_path(@goal), @goal.name
  end

  test "can reactivate an inactive goal" do
    @goal.update_attributes({ active: false })
    assert_equal 1, @user.goals.inactive.count
    get inactive_goals_path(as: @user)
    assert_select "li#goal_#{@goal.id} .goal_active_toggle.toggle_off"

    patch set_active_goal_path(@goal, as: @user, format: :json),
      params: { active: true }
    assert_response :success
    assert_equal "application/json", @response.content_type

    assert_equal 0, @user.goals.inactive.count
  end

  test "inactive goals should be have active_toggle off" do
    @goal.update_attributes(active: false)
    get inactive_goals_path(as: @user)
    assert_select "#goal_#{@goal.id}.inactive_goal .goal_active_toggle.toggle_off input"
  end

end
