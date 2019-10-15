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

  def edit_recurrence
    @recurrence_form = RecurrenceForm.new(
      happening: @happening,
      day: @happening.start_date.wday,
      every: t('recurrences_every').first.first,
      total: 1,
      hour: @happening.discipline_happenings.order(start_time: :asc).first&.start_time&.hour,
      min: @happening.discipline_happenings.order(start_time: :asc).first&.start_time&.min,
    )
    render partial: 'recurrence_form', layout: false
  end

  def update_recurrence
    @recurrence_form = RecurrenceForm.new(
      *_recurrence_form_params.merge(
        happening: @happening,
      )
    )
    return if params[:button] == 'preview'

    update_and_render_or_redirect_in_js(
      @recurrence_form,
      _recurrence_form_params, admin_happening_path(@happening),
      'recurrence_form',
      helpers.t_notice_count('successfully_created', Happening, @recurrence_form.preview.size),
    )
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
    redirect_to admin_happenings_path, notice: helpers.t_notice('successfully_deleted', Happening)
  end

  def _set_happening
    @happening = Happening.find params[:id]
  end

  def _happening_params
    params.require(:happening).permit(
      *Happening::FIELDS, :existing_or_new, :venue_id, :club_id,
      venue_attributes: Venue::FIELDS,
    )
  end

  def _recurrence_form_params
    params.require(:recurrence_form).permit(*RecurrenceForm::FIELDS)
  end
end
