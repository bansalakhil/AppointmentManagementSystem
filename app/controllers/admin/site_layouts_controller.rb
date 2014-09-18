class Admin::SiteLayoutsController < Admin::BaseController
  before_action :get_current_layout, only: [:edit, :update]

  def edit
    # FIX- Handle case when there is no SiteLayout present
  end

  def update

    if @site_layout.update(site_layout_params)
      flash[:notice] = 'Upload successful'
    else
      flash[:error] = 'Upload failed'
    end
    redirect_to edit_admin_site_layout_path
  end

  private

  def get_current_layout
    @site_layout = current_layout
  end

  def site_layout_params
    params.require(:site_layout).permit(:logo, :background)
  end
end
