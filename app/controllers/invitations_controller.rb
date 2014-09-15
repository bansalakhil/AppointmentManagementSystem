class InvitationsController < Devise::InvitationsController
  def update
    self.resource = accept_resource

    if resource.errors.empty?
      yield resource if block_given?
      flash_message = resource.active_for_authentication? ? :updated : :updated_not_active                                                                                        
      set_flash_message :notice, flash_message
      #removed the line below to destroy session
      # sign_in(resource_name, resource)
      respond_with resource, location: '/'
    else
      respond_with_navigational(resource){ render :edit }
    end
  end

end