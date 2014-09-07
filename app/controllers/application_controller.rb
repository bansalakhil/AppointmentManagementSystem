class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authorize, unless: :devise_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :validate_access, unless: :skip_validation?

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
    accept_user_invitation_path
  end

  def redirect_to_path(path)
    redirect_to path
  end

  private

  def welcome_controller?
    params[:controller] == 'welcome' ? true : false
  end

  def skip_validation?
    devise_controller? || welcome_controller?
  end

  def validate_access
    namespace = ((params[:controller]).scan(/^(\w+)\//i).flatten).first
    redirect_to welcome_path unless (current_user.type).downcase == namespace
  end

  def authorize
    redirect_to "/" unless user_signed_in?
  end

end
