class RegistrationsController < Devise::RegistrationsController
  skip_before_action :authorize

  def new
    @invitation = Invitation.where(invitation_token: params[:token]).first if params[:token]
    super
  end

  protected

  def after_inactive_sign_up_path_for(resource)
    new_signee_path
  end

end
