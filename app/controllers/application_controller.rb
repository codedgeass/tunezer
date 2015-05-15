class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  before_action :configure_permitted_parameters, if: :devise_controller?
    
  private # ====================================================================================================
  
  
  
  protected # ====================================================================================================

  def configure_permitted_parameters # Sanitizes and whitelists parameters to be sent to the Devise model.
    devise_parameter_sanitizer.for(:sign_up) { 
      |u| u.permit(:admin, :username, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { 
      |u| u.permit(:username, :email, :password, :password_confirmation, :current_password) }
  end
end