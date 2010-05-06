class Admin::FirbTextCardsController < Admin::AdminSiteController

  hobo_model_controller

  auto_actions :all

  def index
    @firb_text_cards = FirbTextCard.paginate(:page => params[:page], :prefetch_relations => true)
  end
  
  def show
    @firb_text_card = FirbTextCard.find(params[:id], :prefetch_relations => true)
  end

  def create
    txt = FirbTextCard.create_card(params[:firb_text_card][:parafrasi], params[:firb_text_card][:anastatica], params[:firb_text_card][:image_zone])
    
    if(txt.save)
      flash[:notice] = "Text page succesfully created"
    else
      flash[:notice] = "Error creating the page"
    end
    
    attach_file_to(txt)

    if (params[:firb_text_card][:note])
      FirbNote.create_notes(params[:firb_text_card][:note].values, txt)
    end
    
    redirect_to :controller => :firb_text_cards, :action => :index
  end

  def destroy
    p = FirbTextCard.find(params[:id])
    if (p.remove)
      flash[:notice] = "Text page removed"
    else
      flash[:notice] = "Error removing the text page"
    end
    redirect_to :controller => :firb_text_cards, :action => :index
  end

  def update
    p = FirbTextCard.find(params[:id])
    p.anastatica = FirbAnastaticaPage.find(params[:firb_text_card][:anastatica]) unless(params[:firb_text_card][:anastatica].blank?)
    p.image_zone = FirbImageZone.find(params[:firb_text_card][:image_zone]) unless(params[:firb_text_card][:image_zone].blank?)
    p.parafrasi = params[:firb_text_card][:parafrasi] unless(params[:firb_text_card][:parafrasi].blank?)
    
    if (params[:firb_text_card][:note]) 
      FirbNote.replace_notes(params[:firb_text_card][:note], p)
    end

    if (p.save!)
      flash[:notice] = "Text page updated"
    else
      flash[:notice] = "Error updating the text page"
    end
    
    attach_file_to(p)
    redirect_to :controller => :firb_text_cards, :action => :index
  end
  
  private
  
  def attach_file_to(text_card)
    if(params[:firb_text_card][:file])
      puts "GOING TO ATTACH"
      xml_data = TaliaCore::DataTypes::XmlData.new
      xml_data.create_from_data('data.xml', params[:firb_text_card][:file], :options => { :mime_type => 'text/xml' })
      text_card.data_records.destroy_all
      text_card.data_records << xml_data
      text_card.save!
    end
  end

end