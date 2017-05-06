class ApplicationController < ActionController::Base
  include Clearance::Controller
  protect_from_forgery with: :exception

  around_action :set_time_zone, if: :current_user

  private

  def set_time_zone(&block)
    Time.use_zone(current_user.time_zone, &block)
  end
end
