class GoalActivitiesController < ApplicationController
  before_action :require_login
  before_action :get_goal

  def new
    @goal_activity = @goal.goal_activities.build
  end

  def create
    @goal_activity = @goal.goal_activities.build(goal_activity_params)
    if @goal_activity.save
      render 'create'
    else
      @errors = @goal_activity.errors.full_messages
      render 'new'
    end
  end

  def destroy
    @goal_activity = @goal.goal_activities.find(params[:id]).destroy
  end

  private

  def goal_activity_params
    params.require(:goal_activity).permit(:performed_at, :goal_id)
  end

  def get_goal
    @goal = Goal.find(params[:goal_id])
  end
end
