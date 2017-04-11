class HealthStatusesController < ApplicationController
  before_action :require_login

  def index
    respond_to do |format|
      format.html { @health_status_months = current_user.health_statuses.by_month }
      format.json do
        @health_statuses = current_user.health_statuses
        start_date = params[:start_date] || '1 month'
        case start_date
        when '5 days'
          render json: @health_statuses.for_range(6.days.ago)
        when '1 month'
          render json: @health_statuses.for_range(1.month.ago )
        when '3 months'
          render json: @health_statuses.for_range(3.months.ago)
        when '1 year'
          render json: @health_statuses.for_range(1.year.ago)
        end
      end
    end
  end

  def new
    @health_status = current_user.health_statuses.build
  end

  def create
    @health_status = current_user.health_statuses.build(health_status_params)
    if @health_status.save
      redirect_to health_statuses_path
    else
      @errors = @health_status.errors.full_messages
      render :new
    end
  end

  def edit
    @health_status = current_user.health_statuses.find(params[:id])
  end


  def update
    @health_status = current_user.health_statuses.find(params[:id])

    if !@health_status.update_attributes(health_status_params)
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    @health_status = current_user.health_statuses.find(params[:id])
    @health_status.destroy
  end

  private
  def health_status_params
    params.require(:health_status).permit(:mindfulness, :physically_active, :happiness, :diet, :mentally_active, :socially_active)
  end
end
