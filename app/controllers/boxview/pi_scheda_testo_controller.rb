class Boxview::PiSchedaTestoController < Boxview::BaseController

  require 'nokogiri'

  def show
    @resource = PiTextCard.find(params[:id], :prefetch_relations => true)
    id = @resource.data_records.find_by_type_and_location('TaliaCore::DataTypes::XmlData', 'html2.html').id
    record = TaliaCore::DataTypes::DataRecord.find(id)
    @raw_content = record.content_string
    
    @content = ''
    @notes = []
    @fenomeni = []

    v = Nokogiri::HTML.parse(@raw_content)
    
    # Replace a tagged <img> with an IMT container initalized with the 
    # given zones
    v.xpath(".//img[@class='source_img'][contains(@about, '/zones/')]").each do |d|
      @z = ImageZone.find(d['about'], :prefetch_relations => true)
      @image = @z.get_image_parent
      
      imt = "<div><a title='Mostra immagine' class='transcription_image_icon'>SHOW IMAGE</a>"
      imt += "<span class='transcription_img_wrapper hidden'>"
      imt += render_to_string :partial => '/boxview/shared/imageviewer', 
               :locals => {:id => rand(Time.now.to_i), 
                           :base64 => @image.zones_xml(@image.uri, [@z.uri.to_s]),
                           :js_prefix => 'jsapi'}
      imt += '<a title="Apri in un bel box" class="transcription_open_icon">APRI IN BOX</a>'
      imt += '<a title="Chiudi" class="transcription_close_icon">CHIUDI</a>'
      imt += "</span></div>"

      d.replace(Nokogiri::HTML.parse(imt).xpath(".//div")[0])
      
      # Find and remove the consolidated annotation with this image zone
      v.xpath(".//div[@class='consolidatedAnnotation'][contains(@about, '#{d['about']}')]").each do |ca|
        sub_lab = ca.xpath(".//div[@class='subject']/span[@class='label']")[0].text
        if (sub_lab.include? '[image: illustration.jpg]')
          ca.remove
        end
      end
      
    end
    
    # Handle consolidated annotations
    v.xpath(".//div[@class='consolidatedAnnotation']").each do |d|
      pred = d.xpath(".//div[@class='predicate']")[0]['about'];
      ca_class = d.xpath(".//span[@class='annotationClass']")[0].text

      # Has Note
      if (pred == 'http://purl.oclc.org/firb/swn_ontology#hasNote')
        n_name = d.xpath(".//div[@class='object']/span[@class='name']")[0].text
        n_content = d.xpath(".//div[@class='object']/span[@class='content']")[0].text
        @notes.push({:name => n_name, :content => n_content, :class => ca_class})
        d.remove
      end

      # Instance of
      if (pred == 'http://purl.oclc.org/firb/swn_ontology#instanceOf')
        di_id = d.xpath(".//div[@class='object']")[0]['about']
        di = DictionaryItem.find(di_id, :prefetch_relations => true)
        di_type = di.item_type.slice(41,100)
        fen_class = Digest::MD5.hexdigest(di.item_type)
        @fenomeni.push({:name => di.name, :fen_class => fen_class, :item_type => di_type, :class => ca_class})
        v.xpath(".//span[contains(@class, '#{ca_class}')]").each{ |span| span['class'] += " #{fen_class}"  }
        d.remove
      end

      # Has image zone
      if (pred == "http://purl.oclc.org/firb/swn_ontology#hasImageZone")
        # TODO: all of this image zones should get added to the imt
        # initialization of the parent image, if it's present in the
        # page ..
      end

      # Has memory depiction (both illustrated and non illustrated)
      if (pred == 'http://purl.oclc.org/firb/swn_ontology#hasMemoryDepiction')
        md_id = d.xpath(".//div[@class='object']")[0]['about']

        begin
          md = PiIllustratedMdCard.find(md_id, :prefetch_relations => true)
        rescue
          md = PiNonIllustratedMdCard.find(md_id, :prefetch_relations => true)
        else
          # DEBUG: just one class for both ill and non-ill MDs? 
          fen_class = Digest::MD5.hexdigest(pred)
          @fenomeni.push({:name => md.short_description, :fen_class => fen_class, :item_type => "Immagini di memoria", :class => ca_class})
          v.xpath(".//span[contains(@class, '#{ca_class}')]").each{ |span| span['class'] += " #{fen_class}"  }
          d.remove
        end
          
      end
      #d.remove
    end

    # Sort fenomeni by type, name
    @fenomeni.sort! { |a,b| 
      if (a[:item_type].downcase == b[:item_type].downcase)
        a[:name].downcase <=> b[:name].downcase 
      else
        a[:item_type].downcase <=> b[:item_type].downcase 
      end
    }
    
    # The resulting modified HTML is the final content to display
    @content << v.to_s
    
  end
end
