class FirbImageZone < FirbImageElement
  hobo_model # Don't put anything above this
  include StandardPermissions
  
  attr_accessor :image

  singular_property :coordinates, N::TALIA.hasCoordinates
  
  fields do
    uri :string
  end

  declare_attr_type :name, :string
  
  # Creates a new zone. You must pass in the image object to which this zone will 
  # be connected. Optionally, you may also pass in a parent zone
  def self.create_with_name(name)
    new_url = N::LOCAL + 'zones/' + random_id
    raise(ArgumentError, "Record already exists #{new_url}") if(TaliaCore::ActiveSource.exists?(new_url))
    zone = self.new(new_url)
    zone.name = name 
    zone
  end
  
  # Removes the zone and all of its children
  def remove
    
    # Remove all of its subzones
    zones.each{|z| z.remove }
    
    parent = self.get_parent
    parent[N::TALIA.hasSubZone].remove(self)

    self.destroy
    parent.save
  end

  # Gets the parent of this FirbImageZone, either another FirbImageZone or
  # a FirbImage object
  def get_parent
    qry = ActiveRDF::Query.new(FirbImageZone).select(:parent).distinct
    qry.where(:parent, N::TALIA.hasSubZone, self)
    qry.where(:parent, N::RDF.type, N::TALIA.FirbImageZone)
    parent = qry.execute

    if(parent.empty?)
      qry = ActiveRDF::Query.new(FirbImage).select(:parent).distinct
      qry.where(:parent, N::TALIA.hasSubZone, self)
      qry.where(:parent, N::RDF.type, N::TALIA.FirbImage)
      parent = qry.execute
    end
    
    parent.first
  end
  
  # Will recurse on its parents to get the FirbImage
  def get_firb_image_parent
    parent = self.get_parent
    loop do
      break if (parent.class.to_s == "FirbImage")
      parent = parent.get_parent
    end
    parent
  end
  
  
  def self.find_by_name(name)
    ActiveRDF::Query.new(FirbImageZone).select(:zone).where(:zone).where(:zone, N::TALIA.name, name).execute.first
  end

  # Returns the XML describing the polygon that this zone contains
  def polygon
  end
  
  # Set the polygon XML for this zone
  def polygon=(xml)
  end
  
end