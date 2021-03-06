require 'base64'

module AdminHelper
  def admin_toolbar
    widget(:toolbar, :buttons => [ 
        ["Home", {:controller => 'source', :action => 'show', :id => 'Lucca'}], 
        ["Admin", {:action => 'index'} ],
        ["Sources", {:controller => 'admin/sources' }],
        ["Users", { :controller => 'admin/users'} ],
        ["Print Page", "javascript:print();"]
      ] )
  end
  
  # Returns the title for the whole page. This returns the value
  # set in the controller, or a default value
  def page_title
    @page_title || TaliaCore::SITE_NAME
  end
  
  def collection_options
    options = {}
    @collections.each do |col|
    end
  end
  
  # Show each <tt>flash</tt> status (<tt>:notice</tt>, <tt>:error</tt>) only if it's present.
  def show_flash
    [:notice, :error].collect do |status|
      %(<div id="#{status}">#{flash[status]}</div>) unless flash[status].nil?
    end
  end

  # Defines the pages that are visible in the menu
  def active_pages
    %w(users background sources) # translations not working at the moment, templates not ready for generic use
  end

  def original_image_url(image)
    url_for_data_record(image.original_image)
  end

  def thumb_url(image)
    url_for_data_record(image.iip_record)
  end

  def thumb_xml(image, zone_list=nil)
    image.zones_xml(thumb_url(image), zone_list)
  end

  def image_xml(image, url=nil)
    image.zones_xml(original_image_url(image), nil, url)
  end

  def url_for_data_record(record)
    if(record)
      return record.static_path unless record.static_path.nil?
      url_for :controller => '/source_data', :action => 'show', :id => record.id, :only_path => false
    else
      ''
    end
  end

  def not_hidden?(model)
    #!(TaliaCore::CONFIG['hidden_tabs'].include?(model.name.tableize))
    TaliaCore::CONFIG['shown_tabs'].include?(model.name.tableize)
  end
  
  def image_components(components, card)
    render :partial => 'admin/image_components/embedded_form', :locals => { :image_components => components, :new_component => ImageComponent.new, :current_card => card }
  end

  # Selects the action for the base_card forms (since hobo won't do it on the subclasses)
  def base_card_action
    if(@base_card.nil? or @base_card.new_record?)
      url_for(:action => :create, :type => 'false')
    else
      url_for(:action => :update, :id => @base_card.id, :type => 'false')
    end
  end

  # Works on sources which have an associated image_zone (text_page, illustrated memory
  # depictions, ..). Will return its parent image_zone along with its name and the
  # associated image_zone and it's name, if there's any. 
  def parent_and_zone(object)
    if !object.image_zone.nil?
      parent = object.image_zone.get_image_parent
      parent_name = parent.name
      image_zone = object.image_zone
      image_zone_name = image_zone.name
		else
      parent = nil
      image_zone = nil
      parent_name = I18n.t("firb.no_associated_image")
      image_zone_name = I18n.t("firb.no_associated_zone")
		end
		return parent, parent_name, image_zone, image_zone_name
  end

end
