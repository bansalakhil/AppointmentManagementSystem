class RegistrationsController < Devise::RegistrationsController
  skip_before_action :authorize
  protected

  # def after_sign_up_path_for(resource)
  #   availabilities_path
  # end

  def after_inactive_sign_up_path_for(resource)
    new_sign_up_path
  end

end
