class Admin::HappeningsController < Admin::BaseController
  before_action :_set_happening, except: %i[index new create]

  def index
    @happenings = Happening.all
  end

  def show; end

  def new
    @happening = Happening.new
    render partial: 'form', layout: false
  end

  def edit
    render partial: 'form', layout: false
  end

  # JS
  def create
    @happening = Happening.new
    update_and_render_or_redirect_in_js @happening, _happening_params, ->(id) { admin_happening_path(id) }
  end

  # JS
  def update
    update_and_render_or_redirect_in_js @happening, _happening_params, admin_happening_path(@happening)
  end

  def destroy
    @happening.destroy!
    redirect_to admin_happenings_path, notice: helpers.t_notice('notice_successfully_deleted', Happening)
  end

  def _set_happening
    @happening = Happening.find params[:id]
  end

  def _happening_params
    params.require(:happening).permit(
      *Happening::FIELDS
    )
  end
end
