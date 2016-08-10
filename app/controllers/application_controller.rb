class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError do |exception|
    flash[:danger] = "You're not authorized"
    redirect_to request.referrer || root_path
  end

  helper_method :current_user

  private

  def current_user
    return unless session[:id]
    @user ||= User.find_by(id: session[:id])
  end

  def authenticate!
  unless current_user
    redirect_to root_path
    flash[:danger] = "You need to login first"
  end
end
end
