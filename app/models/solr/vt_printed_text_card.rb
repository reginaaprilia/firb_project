module SOLR
  class VtPrintedTextCard < Base
    solr_setup do
      text :ref_edition
      text :name
      # text :page_position


      text :facets
      dynamic_string :facets, :multiple => true, :stored => true do
        facets
      end
    end

    def ref_edition
      VtLetter.edition_title_for bibliography_items.first
    end

  end # class VtPrintedTextCard
end # module SOLR
