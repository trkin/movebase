class HappeningsController < ApplicationController
  before_action :_set_happening, only: %i[show]

  def index
    redirect_to root_path
  end

  def index_for_activities
    @datatable = HappeningsForActivityNamesDatatable.new view_context
  end

  def search_for_activities
    render json: HappeningsForActivityNamesDatatable.new(view_context)
  end

  def index_for_disciplines
    @datatable = HappeningsForDisciplinesDatatable.new view_context
  end

  def search_for_disciplines
    render json: HappeningsForDisciplinesDatatable.new(view_context)
  end

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
