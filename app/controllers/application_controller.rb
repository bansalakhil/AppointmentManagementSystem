class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authorize, unless: :devise_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :validate_access, unless: :skip_validation?

  # FIX- Move to helpers
  def current_layout
    @site_layout ||= SiteLayout.first
  end
  
  helper_method :current_layout

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << [:name, :email, :phone_number, :invitation_token]
  end

  def after_sign_out_path_for(resource)
    new_user_session_path
  end

  def after_sign_in_path_for(resource)
    welcome_path
  end

  def after_accept_path_for(resource)
    # accept_user_invitation_path
    redirect_to "/"
  end

  # FIX- Give any reason to do this?
  def redirect_to_path(path)
    redirect_to path
  end

  private

  def appointment_path?
    namespace = params[:controller].split('/').first
    ['staff', 'customer'].include? namespace && params[:action] == 'get_events'
  end

  # Why?
  #ANS - to prevent redirection if u are already on the welcome page
  def welcome_controller?
    # Discuss
    params[:controller] == 'welcome' ? true : false
  end

  # FIX- What does it do?
  def skip_validation?
    devise_controller? || welcome_controller? || appointment_path?
  end

  # FIX- Define a method in user model to check if admin
  # to check if the user is authorized to access the urls
  def validate_access
    namespace = params[:controller].split('/').first
    redirect_to welcome_path unless (current_user.type).downcase == namespace if current_user
  end

  def authorize
    redirect_to "/" unless user_signed_in?
  end

end
