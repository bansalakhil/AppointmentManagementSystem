class Admin::SiteLayoutsController < Admin::BaseController

  def edit
    @site_layout = current_layout
  end

  def update

    @site_layout = current_layout

    if @site_layout.update(site_layout_params)
      flash[:notice] = 'Upload successful'
    else
      flash[:error] = 'Upload failed'
    end
    redirect_to_path(edit_admin_site_layout_path)
  end

  private
  def site_layout_params
    params.require(:site_layout).permit(:logo, :background)
  end
end
