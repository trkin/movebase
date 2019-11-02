class ClubUsersController < ApplicationUserController
  before_action :_set_club_user, only: %i[edit update destroy]

  def search
    render json: ClubUsersDatatable.new(view_context)
  end

  def edit
    render partial: 'form', layout: false
  end

  def update
    update_and_render_or_redirect_in_js @club_user, _club_user_params, my_club_path
  end

  def destroy
    @club_user.destroy!
    redirect_to my_club_path, notice: helpers.t_notice('successfully_deleted', ClubUser)
  end

  def _club_user_params
    params.require(:club_user).permit(
      *ClubUser::FIELDS
    )
  end

  def _set_club_user
    @club_user = current_user.club.club_users.find params[:id]
  end
end
