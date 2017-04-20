class GoalsController < ApplicationController
  before_action :require_login

  def index
    @goals = current_user.goals
  end
end
