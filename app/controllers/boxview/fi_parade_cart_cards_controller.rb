class Boxview::FiParadeCartCardsController < Boxview::BaseController

  def show
    @resource = FiParadeCartCard.find_by_id params[:id]
    @image    = @resource.image_zone.get_parent
  end
end
