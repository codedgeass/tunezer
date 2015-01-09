class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  helper_method :current_or_guest_user
  
  def current_or_guest_user
    if current_user
      if session[:guest_user_id] && session[:guest_user_id] != current_user.id
        logging_in
        guest_user(with_retry = false).try(:destroy)
        session[:guest_user_id] = nil
      end
      current_user
    else
      guest_user
    end
  end
    
  private # ====================================================================================================
  
  def guest_user(with_retry = true)
    # Cache the value the first time it's retrieved.
    @cached_guest_user ||= User.find(session[:guest_user_id] ||= create_guest_user.id)
  rescue ActiveRecord::RecordNotFound # This exception is thrown when session[:guest_user_id] is invalid.
     session[:guest_user_id] = nil
     guest_user if with_retry
  end

  def create_guest_user
    u = User.new(username: "Guest_#{Time.now.to_i}#{rand(99)}", email: "Guest_#{Time.now.to_i}#{rand(99)}@temp.com")
    u.skip_confirmation!
    u.save!(validate: false)
    session[:guest_user_id] = u.id
    u
  end

  def logging_in
    guest_comments = guest_user.comments.all
    guest_comments.each do |comment|
      comment.user_id = current_user.id
      comment.username = current_user.username
      comment.save!
    end
  end
  
  protected # ====================================================================================================

  def configure_permitted_parameters # Sanitizes and whitelists parameters to be sent to the Devise model.
    devise_parameter_sanitizer.for(:sign_up) { 
      |u| u.permit(:admin, :username, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { 
      |u| u.permit(:username, :email, :password, :password_confirmation, :current_password) }
  end
end