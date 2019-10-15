class Admin::DisciplineHappeningsController < Admin::BaseController
  before_action :_set_happening, only: %i[new create]
  before_action :_set_discipline_happening, except: %i[new create]

  def new
    @discipline_happening = @happening.discipline_happenings.new(
      discipline: @happening.discipline_happenings.last&.discipline,
      start_time: @happening.discipline_happenings.last&.start_time || @happening.start_date
    )
    @discipline_happening.build_discipline if @discipline_happening.discipline.blank?
    render partial: 'form', layout: false
  end

  def edit
    render partial: 'form', layout: false
  end

  # JS
  def create
    @discipline_happening = @happening.discipline_happenings.new
    update_and_render_or_redirect_in_js \
      @discipline_happening, _discipline_happening_params, ->(_id) { admin_happening_path(@happening) }
  end

  # JS
  def update
    update_and_render_or_redirect_in_js \
      @discipline_happening, _discipline_happening_params, admin_happening_path(@discipline_happening.happening)
  end

  def destroy
    @discipline_happening.destroy!
    redirect_to \
      admin_happening_path(@discipline_happening.happening),
      notice: helpers.t_notice('successfully_deleted', DisciplineHappening)
  end

  def _set_happening
    @happening = Happening.find params[:happening_id]
  end

  def _set_discipline_happening
    @discipline_happening = DisciplineHappening.find params[:id]
  end

  def _discipline_happening_params
    params.require(:discipline_happening).permit(
      *DisciplineHappening::FIELDS, :existing_or_new, :discipline_id,
      discipline_attributes: Discipline::FIELDS,
    )
  end
end
