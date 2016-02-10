class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in) do |user_params|
      user_params.permit(:username, :email)
    end
  end
  protected
  private
  def configure_permitted_parameters
     devise_parameter_sanitizer.for(:sign_in)        << :id
     devise_parameter_sanitizer.for(:sign_up)        << :id
     devise_parameter_sanitizer.for(:account_update) << :id
  end
end
