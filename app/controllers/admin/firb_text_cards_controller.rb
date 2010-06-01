require 'simplyx'
class Admin::FirbTextCardsController < Admin::AdminSiteController

  hobo_model_controller
  

  auto_actions :all

  def index
    @firb_text_cards = FirbTextCard.paginate(:page => params[:page], :prefetch_relations => true)
  end
  
  def show
    @firb_text_card = FirbTextCard.find(params[:id], :prefetch_relations => true)
  end

  def show_annotable
    record = TaliaCore::DataTypes::DataRecord.find(params[:id])
    @content = record.content_string
  end

  def create
    txt = FirbTextCard.create_card(params[:firb_text_card])
    
    if(save_created!(txt))
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
    hobo_destroy { redirect_to :controller => :firb_text_cards, :action => :index }
  end

  def update
    hobo_source_update do |updated_source|
      if (params[:firb_text_card][:note]) 
        FirbNote.replace_notes(params[:firb_text_card][:note], updated_source)
      end
      redirect_to :controller => :firb_text_cards, :action => :index
    end
  end
  
  private
  
  def attach_file_to(text_card)
    if(params[:firb_text_card][:file])
      xml_data = TaliaCore::DataTypes::XmlData.new
      xml_data.create_from_data('data.xml', params[:firb_text_card][:file], :options => { :mime_type => 'text/xml' })
      text_card.data_records.destroy_all
      text_card.data_records << xml_data
      options = {"source_uri" => text_card.uri.to_s }
      xsl_file = 'xslt/HTML1.xsl'
      xml_file = xml_data.full_filename
      html1 = Simplyx::XsltProcessor::perform_transformation(xsl_file, xml_file, options)
      html1_data = TaliaCore::DataTypes::XmlData.new
      html1_data.create_from_data('html1.html', html1, :options => { :mime_type => 'text/html' })
      text_card.data_records << html1_data
      text_card.save!
    end
  end

end