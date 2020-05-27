class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery

  helper_method :current_user
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  helper_method :logged_in?
  def logged_in?
    !current_user.nil?
  end

  def verify_logged_in
    user_not_authorized if current_user.nil?
  end

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    redirect_to root_path, alert: 'Access denied. You must login as an authorized user.'
  end
end
