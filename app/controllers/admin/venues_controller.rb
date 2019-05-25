class Admin::VenuesController < Admin::BaseController
  before_action :_set_venue, except: %i[index new create]

  def index
    @venues = Venue.all
  end

  def show; end

  def new
    @venue = Venue.new
    render partial: 'form', layout: false
  end

  def edit
    render partial: 'form', layout: false
  end

  # JS
  def create
    @venue = Venue.new
    update_and_render_or_redirect_in_js @venue, _venue_params, ->(id) { admin_venue_path(id) }
  end

  # JS
  def update
    update_and_render_or_redirect_in_js @venue, _venue_params, admin_venue_path(@venue)
  end

  def destroy
    @venue.destroy!
    redirect_to admin_venues_path, notice: helpers.t_notice('notice_successfully_deleted', Venue)
  end

  def _set_venue
    @venue = Venue.find params[:id]
  end

  def _venue_params
    params.require(:venue).permit(
      *Venue::FIELDS
    )
  end
end
