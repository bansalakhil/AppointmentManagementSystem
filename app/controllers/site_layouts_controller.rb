class SiteLayoutsController < ApplicationController

  def edit
    @site_layout = current_layout
  end

  def update

    @site_layout = current_layout

    if @site_layout.update(site_layout_params)
      flash[:notice] = 'Upload successful'
    else
      flash[:notice] = 'Upload failed'
    end
    redirect_to_path(edit_site_layout_path)
  end

  private
  def site_layout_params
    params.require(:site_layout).permit(:logo, :background)
  end
end
