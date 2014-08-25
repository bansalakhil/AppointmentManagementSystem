class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def current_layout
    @site_layout ||= SiteLayout.first
  end
  
  helper_method :current_layout
end
