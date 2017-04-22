class GoalsController < ApplicationController
  before_action :require_login

  def index
    @goals = current_user.goals
  end

  def new
    @goal = current_user.goals.build
  end

  def create
    @goal = current_user.goals.build(goal_params)
    if @goal.save
      render 'create'
    else
      @errors = @goal.errors.full_messages
      render 'new'
    end
  end

  def show
    @goal = current_user.goals.find(params[:id])
  end

  def destroy
    @goal = current_user.goals.find(params[:id]).destroy
    flash[:notice] = "#{@goal.name} has been removed."
    redirect_to goals_path
  end

  private
  def goal_params
    params.require(:goal).permit(:name, :frequency, :description)
  end
end
