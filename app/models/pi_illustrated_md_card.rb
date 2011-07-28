class PiIllustratedMdCard < IllustrationCard
  
  include StandardPermissions
  extend Mixin::Showable
  showable_in PiIllustrationCard
  
  autofill_uri :force => true
  
  # Short description: brief desc. of the depiction, say "Male person
  # drawing"
  singular_property :short_description, N::TALIA.short_description
  declare_attr_type :short_description, :text
  singular_property :transcription_text, N::TALIA.transcription
  declare_attr_type :transcription_text, :text
  singular_property :parent_card, N::TALIA.parent_card, :type => TaliaCore::ActiveSource
  singular_property :content_type, N::DCT.type

  def boxview_data
    desc = self.short_description.nil? ? "" : self.short_description
    { :controller => 'boxview/illustrazioni_figlie', 
      :title => "Scheda immagine di memoria: #{desc}", 
      :description => desc,
      :res_id => "pi_illustration_#{self.id}", 
      :box_type => 'image',
      :thumb => nil
    }
  end

  def is_public?
    true
  end

end
