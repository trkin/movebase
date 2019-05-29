class Admin::ActivityClubsController < Admin::BaseController
  before_action :_set_club, only: %i[new create]
  before_action :_set_activity_club, except: %i[new create]

  def new
    @activity_club = @club.activity_clubs.new
    render partial: 'form', layout: false
  end

  def create
    @activity_club = @club.activity_clubs.new
    update_and_render_or_redirect_in_js @activity_club, _activity_club_params, admin_club_path(@club)
  end

  def destroy
    @activity_club.destroy!
    redirect_to admin_club_path(@activity_club.club), notice: helpers.t_notice('successfully_deleted', ActivityClub)
  end

  def _activity_club_params
    params.require(:activity_club).permit(
      :activity_id
    )
  end

  def _set_club
    @club = Club.find params[:club_id]
  end

  def _set_activity_club
    @activity_club = ActivityClub.includes(:club).find params[:id]
  end
end
