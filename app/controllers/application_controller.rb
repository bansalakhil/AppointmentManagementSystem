class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_layout
    @site_layout ||= SiteLayout.first
  end
  
  helper_method :current_layout
end
