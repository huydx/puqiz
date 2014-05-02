class ApplicationController < ActionController::Base
  protect_from_forgery
  rescue_from ActionController::RoutingError, :with => :render_not_found

  def render_not_found; end
end
