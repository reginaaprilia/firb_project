# Represents a Cart (Carro) in the Parade of FIRB FI
class FiParadeCartCard < IllustrationCard
  
  include FiCardsCommonFields
  extend FiCardsCommonFields::DefinedProperties
  include Mixin::HasParts
  include Mixin::Searchable

  common_properties

  # Bibliografia moderna
  multi_property :modern_bibliography_items, N::TALIA.hasModernBibliograhy, :type => TaliaCore::ActiveSource

  fields do
    uri :string
  end

  autofill_uri :force => true

  # @collection is a TaliaCore::Collection
  # returns the ordered list of element to be shown in the menu list
  def self.menu_items_for(collection)
    result = []
    cards = self.find(:all)
    cards.each do |c|
      my_index = collection.index(c)
      result[my_index] = c unless my_index.nil? #or !c.is_public?
    end
    result.compact
  end

  def deity
    @deity  ||= FiDeityCard.find :first, :find_through => [N::TALIA.cart, self.uri]
  end

  def throne
    @throne ||= FiThroneCard.find :first, :find_through => [N::TALIA.cart, self.uri]
  end

  def vehicle
    @vehicle ||= FiVehicleCard.find :first, :find_through => [N::TALIA.cart, self.uri]
  end

  def animal
    @animal ||= FiAnimalCard.find :first, :find_through => [N::TALIA.cart, self.uri]
  end

  # TODO: intelligent conversion to string?
  def procession_position
    procession.index(self).to_i + 1
  end

  def procession_characters
    procession.select {|el| el.is_a? FiCharacterCard}
  end

  def children
    [deity, throne, vehicle, animal].compact
  end

  def boxview_data
    title = "Carta #{self.anastatica.page_position} - #{self.name}"
    { :controller => 'boxview/fi_parade_cart_cards', 
      :title => title,
      :description => '',
      :res_id => "fi_parade_cart_card_#{self.id}", 
      :box_type => 'image',
      :thumb => nil
    }
  end

  # FIXME (and remove me!)
  # def fetch_procession
  #   if super.is_a? FiProcession
  #     super
  #   else
  #     ActiveRDF::Query.new(FiProcession).select(:procession).where(:procession, N::DCT.hasPart, self).execute
  #   end
  # end

  ##
  # Used by Mixin::HasParts
  def parts_query
    ActiveRDF::Query.new(TaliaCore::ActiveSource).select(:part).where(:part, N::DCT.isPartOf, self)
  end

  def additional_parts
    c = self.children || []
    n = self.notes || []
    c + n
  end

  ##
  # Rewrite of HasParts#can_show? to make all parts "showable".
  # TODO: possible misunderstanding of the request here. Check if this should follow the standard procedure instead.a
  #
  def can_show?(klass)
    true
  end
end
