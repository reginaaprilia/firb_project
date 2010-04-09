class Admin::FirbIllustratedMemoryDepictionsController < Admin::AdminSiteController

  hobo_model_controller

  auto_actions :all

  def create
    txt = FirbTextPage.create_page(params[:firb_text_page][:parafrasi], params[:firb_text_page][:anastatica], params[:firb_text_page][:image_zone])
    
    if(txt.save)
      flash[:notice] = "Text page succesfully created"
    else
      flash[:notice] = "Error creating the page"
    end

    if (params[:firb_text_page][:note])
      FirbNote.create_notes(params[:firb_text_page][:note], txt)
    end
    redirect_to :controller => :firb_text_pages
  end

  def remove_page
    p = FirbTextPage.find(params[:id])
    if (p.remove)
      flash[:notice] = "Text page removed"
    else
      flash[:notice] = "Error removing the text page"
    end
    redirect_to :controller => :firb_text_pages
  end

  def update
    p = FirbTextPage.find(params[:id])
    p.anastatica = FirbAnastaticaPage.find(params[:firb_text_page][:anastatica])
    p.image_zone = FirbImageZone.find(params[:firb_text_page][:image_zone])
    
    if (params[:firb_text_page][:note]) 
      FirbNote.replace_notes(params[:firb_text_page][:note], p)
    end

    if (p.save!)
      flash[:notice] = "Text page updated"
    else
      flash[:notice] = "Error updating the text page"
    end
    redirect_to :controller => :firb_text_pages
  end

end