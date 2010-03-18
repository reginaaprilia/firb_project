class FirbImageElement < TaliaCore::Source

  singular_property :name, N::TALIA.name

  # Creates a random id string
  def self.random_id
    rand Time.now.to_i
  end
  
  def random_id
    self.class.random_id
  end

  # Returns the number of zones directly linked to this object
  def zone_count
    @zones=zones
    @count = @zones.count
    @zones.each{ |z| @count += z.zone_count }
    @count
  end

  # Returns the FirbImageZone sources which is part of this object
  def zones
    qry = ActiveRDF::Query.new(FirbImageZone).select(:zone).distinct
    qry.where(:zone, N::TALIA.hasSubZone, self)
    qry.execute
  end

  def has_zones
    zone_count > 0
  end

  # Adds a new, empty zone to this object.
  def add_zone(name)
    zone = FirbImageZone.create_with_name(name)
    self[N::TALIA.hasSubZone] << zone
    zone.save!
    zone
  end
  
  # Updates all zones from the given XML file (from the Image Mapper Tool)
  def update_zones(xml)
  end


  # Returns the XML for the "Zones" polygons. This returns an XML which can be
  # passed to the Image Mapper Tool
  def zones_xml
    doc = REXML::Document.new
    doc << REXML::XMLDecl.new
    root = REXML::Element.new("dctl_ext_init")
    doc.add_element(root)
    # First we fill the <img> tag which contains information on the image to use
    image = root.add_element(REXML::Element.new("img"))
    image_a = image.add_element(REXML::Element.new("a"))
    # this "s" attribute used to have some meaningful values, but they are outdated now, and we'll use this standard value
    image_a.add_attribute("s", "image.jpg")
    image_a.add_attribute("l", '') #TODO FILL IN WITH THE IMAGE FILE URI)
    image_a.add_attribute("l", self.name)
    zones_node = root.add_element(REXML::Element.new("xml"))
    zones.each do |z|
      add_zone_to_xml(z, zones_node)
    end
    doc.to_s
  end

  def add_zone_to_xml(zone, zones_node)
    zone_node = zones_node.add_element(REXML::Element.new("a"))
    zone_node.add_attribute("l", zone.name)
    zone_node.add_attribute("s",'')
    zone.zones.each{|z| add_zone_to_xml(z, zone_node)} if zone.has_zones
  end


end
