class SiteLayoutsController < ApplicationController

  def edit
    @site_layout = current_layout
  end

  def update

    @site_layout = current_layout
    @site_layout.update(site_layout_params)
    redirect_to edit_site_layout_path
  end

  private
  def site_layout_params
    params.require(:site_layout).permit(:logo, :background)
  end
end
