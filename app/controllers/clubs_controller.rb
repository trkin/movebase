class ClubsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[search]
  before_action :_set_club, except: %i[index search]

  def index
    @datatable = ClubsDatatable.new view_context
  end

  def search
    render json: ClubsDatatable.new(view_context)
  end

  def show
    @datatable = HappeningsForClubDatatable.new view_context
  end

  def search_happenings
    render json: HappeningsForClubDatatable.new(view_context)
  end

  def _set_club
    @club = Club.find params[:id]
  end
end
