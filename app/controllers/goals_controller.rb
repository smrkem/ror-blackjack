class GoalsController < ApplicationController
  before_action :require_login

  def index
    @goals = current_user.goals.active
  end

  def inactive_goals
    @goals = current_user.goals.inactive
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
    @previous_activity = @goal.goal_activities.by_week
  end

  def edit
    @goal = current_user.goals.find(params[:id])
  end

  def update
    @goal = current_user.goals.find(params[:id])

    if @goal.update_attributes(goal_params)
      render 'update'
    else
      @errors = @goal.errors.full_messages
      render 'edit'
    end
  end

  def destroy
    @goal = current_user.goals.find(params[:id]).destroy
    flash[:notice] = "#{@goal.name} has been deleted."
    redirect_to goals_path
  end

  def set_active
    @goal = current_user.goals.find(params[:id])
    active =  params['active'] == "true" ? true : false
    @goal.update_attributes({active: active})
    render json: @goal
  end

  def complete_now
    respond_to do |format|
      format.json do
        @goal = current_user.goals.find(params[:id])
        @goal.goal_activities.create(performed_at: Time.current)
        render json: { goal_completes: @goal.completions, goal_completed: @goal.week_completed? }
      end
    end
  end

  def deactivate
    @goal = current_user.goals.find(params[:id])
    @goal.deactivate
    flash[:notice] = "#{@goal.name} has been removed."
    redirect_to goals_path
  end

  private
  def goal_params
    params.require(:goal).permit(:name, :frequency, :description)
  end
end
