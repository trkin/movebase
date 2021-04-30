class Admin::UserRolesController < Admin::BaseController
  before_action :_set_user, only: %i[index new create]
  before_action :_set_user_role, except: %i[index new create]

  def new
    @user_role = @user.user_roles.new
    render partial: 'form', layout: false
  end

  def edit
    render partial: 'form', layout: false
  end

  # JS
  def create
    @user_role = @user.user_roles.new
    update_and_render_or_redirect_in_js @user_role, _user_role_params, ->(user_role) { admin_user_path(user_role.user) }
  end

  # JS
  def update
    update_and_render_or_redirect_in_js \
      @user_role, _user_role_params, admin_user_path(@user_role.user)
  end

  def destroy
    @user_role.destroy!
    redirect_to admin_user_path(@user_role.user), notice: helpers.t_notice('successfully_deleted', UserRole)
  end

  def _set_user
    @user = User.find params[:user_id]
  end

  def _set_user_role
    @user_role = UserRole.find params[:id]
  end

  def _user_role_params
    params.require(:user_role).permit(
      *UserRole::FIELDS
    )
  end
end
