class Admin::DisciplineHappeningsController < Admin::BaseController
  before_action :_set_discipline_happening, except: %i[index new create]

  def index
    @discipline_happenings = DisciplineHappening.all
  end

  def show; end

  def new
    @discipline_happening = DisciplineHappening.new
    render partial: 'form', layout: false
  end

  def edit
    render partial: 'form', layout: false
  end

  # JS
  def create
    @discipline_happening = DisciplineHappening.new
    update_and_render_or_redirect_in_js \
      @discipline_happening, _discipline_happening_params, ->(id) { admin_happening_path(id) }
  end

  # JS
  def update
    update_and_render_or_redirect_in_js \
      @discipline_happening, _discipline_happening_params, admin_happening_path(@discipline_happening.happening)
  end

  def destroy
    @discipline_happening.destroy!
    redirect_to \
      admin_discipline_happenings_path, notice: helpers.t_notice('notice_successfully_deleted', DisciplineHappening)
  end

  def _set_discipline_happening
    @discipline_happening = DisciplineHappening.find params[:id]
  end

  def _discipline_happening_params
    params.require(:discipline_happening).permit(
      *DisciplineHappening::FIELDS
    )
  end
end
