class MyClubsController < ApplicationUserController
  before_action :_set_club, only: %i[edit update]
  def show
    @datatable = ClubUsersDatatable.new view_context
  end

  def new
    @club = Club.new
    render partial: 'form', layout: false
  end

  def create
    @club = current_user.build_club
    add_to_club = proc do |_id|
      current_user.club = @club
      current_user.save!
      current_user.club_users.create! club: @club, status: ClubUser.statuses[:admin]
      my_club_path
    end
    update_and_render_or_redirect_in_js @club, _club_params, add_to_club
  end

  def edit
    render partial: 'form', layout: false
  end

  def update
    update_and_render_or_redirect_in_js @club, _club_params, my_club_path
  end

  def _club_params
    params.require(:club).permit(
      *Club::FIELDS, :existing_or_new_venue, :venue_id,
      venue_attributes: Venue::FIELDS,
    )
  end

  def _set_club
    @club = current_user.club
  end
end
