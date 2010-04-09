class FirbIllustratedMemoryDepiction < FirbMemoryDepiction
  hobo_model # Don't put anything above this
  include StandardPermissions
  
  attr_accessor :image

  singular_property :image_zone, N::DCT.isFormatOf

  # Code: internal identifier used by the owner of the original source
  # to archive it
  singular_property :code, N::TALIA.identifier
  declare_attr_type :code, :string

  # Collocation: phisical place where the original manuscript
  # (or, in general, the original source) can be found or is conserved
  singular_property :collocation, N::TALIA.provenance
  declare_attr_type :collocation, :string

  # Tecnique: used to describe the way the image has been drawn
  # say: "oil on paper" or "pencil on wood"
  singular_property :tecnique, N::TALIA.tecnique
  declare_attr_type :tecnique, :string

  # Measure: describes the phisical dimensions of the depiction
  # usually in centimeters
  singular_property :measure, N::TALIA.measure
  declare_attr_type :measure, :text
  
  # Position: describes the position of the depiction inside the
  # "big picture", say "upper left corner" or "bottom part"
  singular_property :position, N::DCT.position
  declare_attr_type :position, :string
  
  # Descriptive notes: some notes which describes the depiction, meant to
  # be a kinf of appendix of the description field
  singular_property :descriptive_notes, N::TALIA.descriptive_notes
  declare_attr_type :descriptive_notes, :text

  # Study notes: some informations about the depiction, say "four depictions
  # are positioned clockwise in the four corners of a room with gray floor
  # and green walls. The fifth depiction is positioned between the door and
  # and the fourth depiction"
  singular_property :study_notes, N::TALIA.study_notes
  declare_attr_type :study_notes, :text

  # Description: long description of the depiction, say "Male person
  # dressed in green and red, with a white hat and long brown hair, is
  # using his left hand to draw while the right one is keeping a cross on
  # his chest"
  singular_property :description, N::TALIA.description
  declare_attr_type :description, :text

  # Short description: brief desc. of the depiction, say "Male person
  # drawing"
  singular_property :short_description, N::TALIA.short_description
  declare_attr_type :short_description, :text

  # Completed: true if the depiction is fully completed or false if
  # say some colors are not on their place or some parts are only sketched
  singular_property :completed, N::TALIA.completed
  declare_attr_type :completed, :boolean

  
  fields do
    uri :string
  end
  
end