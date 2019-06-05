class HappeningsController < ApplicationController
  before_action :_set_happening, except: %i[index search]

  def index
    @search_happenings = SearchHappenings.new _search_happenings_params
  end

  def search; end

  def show; end

  def _set_happening
    @happening = Happening.find params[:id]
  end

  def _happening_params
    params.require(:happening).permit(
      *Happening::FIELDS, :existing_or_new, :venue_id, :club_id,
      venue_attributes: Venue::FIELDS,
    )
  end

  def _search_happenings_params
    params.require(:search_happenings).permit(
      :venue_id, :activity_id
    )
  end
end
