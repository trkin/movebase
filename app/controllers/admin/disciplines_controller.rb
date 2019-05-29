class Admin::DisciplinesController < Admin::BaseController
  before_action :_set_discipline, except: %i[index new create]

  def index
    @disciplines = Discipline.all
  end

  def show; end

  def new
    @discipline = Discipline.new
    render partial: 'form', layout: false
  end

  def edit
    render partial: 'form', layout: false
  end

  # JS
  def create
    @discipline = Discipline.new
    update_and_render_or_redirect_in_js @discipline, _discipline_params, ->(id) { admin_discipline_path(id) }
  end

  # JS
  def update
    update_and_render_or_redirect_in_js @discipline, _discipline_params, admin_discipline_path(@discipline)
  end

  def destroy
    @discipline.destroy!
    redirect_to admin_disciplines_path, notice: helpers.t_notice('successfully_deleted', Discipline)
  end

  def _set_discipline
    @discipline = Discipline.find params[:id]
  end

  def _discipline_params
    params.require(:discipline).permit(
      *Discipline::FIELDS
    )
  end
end
