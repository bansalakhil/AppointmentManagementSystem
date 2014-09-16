class Admin::InvitationsController < Admin::BaseController
  skip_before_action :authorize, only: [:accept]
  PERMITTED_ATTRS = [:name, :email]

  def new
    @invitation = Invitation.new
    respond_to do |format|
      format.js { render :action => "new" }
    end
  end
  def create
    @invitation = Invitation.new(invitation_params)
    respond_to do |format|
      if @invitation.save
        # @customer.invite!
        format.js { render :action => "create" }
      else
        format.js { render :action => "new" }
      end
    end
  end

  def accept
    invitation = Invitation.where(invitation_token: params[:token]).first
    if invitation
      invitation.accept!
    else
      flash[:errors] = 'Invalid token'
    end
    redirect_to new_user_registration_path(token: params[:token])
  end

  def invitation_params
    params.require(:invitation)
      .permit(*PERMITTED_ATTRS)
  end
end