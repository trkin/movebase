class Admin::ClubsController < Admin::BaseController
  before_action :_set_club, except: %i[index search new create]

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

  def new
    @club = Club.new
    render partial: 'form', layout: false
  end

  def edit
    render partial: 'form', layout: false
  end

  # JS
  def create
    @club = Club.new
    update_and_render_or_redirect_in_js @club, _club_params, ->(id) { admin_club_path(id) }
  end

  # JS
  def update
    update_and_render_or_redirect_in_js @club, _club_params, admin_club_path(@club)
  end

  def destroy
    @club.destroy!
    redirect_to admin_clubs_path, notice: helpers.t_notice('successfully_deleted', Club)
  end

  def _set_club
    @club = Club.find params[:id]
  end

  def _club_params
    params.require(:club).permit(
      *Club::FIELDS, :existing_or_new, :venue_id,
      venue_attributes: Venue::FIELDS,
    )
  end
end
