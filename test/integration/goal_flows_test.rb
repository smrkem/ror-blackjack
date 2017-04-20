require 'test_helper'

class GoalFlowsTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "index for user shows list of their own goals" do
    get goals_path(as: @user)
    assert_select "li.goal", "Test Goal 1"
    assert_select "li.goal", { count: 0, text: goals(:two).name }
  end

end
