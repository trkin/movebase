class Admin::HappeningsController < Admin::BaseController
  before_action :_set_happening, except: %i[index new create parse_url]

  def index
    @happenings = Happening.all
  end

  def show; end

  def new
    @happening = Happening.new(
      club_id: params[:club_id]
    )
    render partial: 'form', layout: false
  end

  def edit
    render partial: 'form', layout: false
  end

  def edit_recurrence
    @recurrence_form = RecurrenceForm.new(
      happening: @happening,
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
      helpers.t_notice_count('successfully_created', Happening, @recurrence_form.take_dates.size),
    )
  end

  # JS
  def create
    @happening = Happening.new(
      club_id: params[:club_id]
    )
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

  def parse_url
    result = ParseUrl.new(params[:url]).perform
    if result.success?
      render json: result.data[:json]
    else
      render json: { error: result.message }
    end
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
