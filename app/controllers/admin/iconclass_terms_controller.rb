class Admin::IconclassTermsController < Admin::AdminSiteController

  hobo_model_controller
  

  auto_actions :all
  
  def index
    @iconclass_terms = IconclassTerm.paginate(:page => params[:page], :prefetch_relations => true)
  end
  
  def edit
    @iconclass_term = IconclassTerm.find(params[:id], :prefetch_relations => true)
  end
  
  def create
    @iconclass_term = IconclassTerm.create_term(params[:iconclass_term])
    if(save_created(@iconclass_term))
      flash[:notice] = "Iconclass term successfully created"
    else
      flash[:notice] = "Error creating term"
    end
    redirect_to :action => 'index'
  end
  
  def update
    hobo_source_update(:find_options => { :prefetch_relations => true }) { redirect_to :action => :index }
  end
  
  def autocomplete
    value = params[:value]
    raise(ArgumentError, "Parameter missing") unless(value)
    query = ActiveRDF::Query.new(IconclassTerm).select(:term, :alt_label, :pref_label)
    query.where(:term, N::SKOS.prefLabel, :pref_label)
    query.where(:term, N::SKOS.altLabel, :alt_label)
    @completions = query.execute
    @completions.reject! do |term, alt_label, pref_label|
      !(
        term.term =~ /#{value}/i ||
        alt_label =~ /#{value}/i ||
        pref_label =~ /#{value}/i
      )
    end
  end
  
end