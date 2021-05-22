class HappeningsController < ApplicationController
  before_action :_set_happening, only: %i[show edit update destroy]
  before_action :authenticate_user!, except: %i[index search show]

  def index
    @datatable = HappeningsForDisciplinesDatatable.new view_context
  end

  def search
    render json: HappeningsForDisciplinesDatatable.new(view_context)
  end

  def show; end

  def new
    @happening = Happening.new
    authorize! @happening, to: :update?
    @happening.discipline_happenings.build discipline_id: params[:discipline_id]
    render partial: 'new_form', layout: false
  end

  def edit
    authorize! @happening
    render partial: 'edit_form', layout: false
  end

  def new_from_link
    authorize!
    @add_happening_from_link_form = AddHappeningFromLinkForm.new url: params[:url], discipline_id: params[:discipline_ids]&.first
    render layout: false
  end

  def edit_from_link
    authorize!
    @add_happening_from_link_form = AddHappeningFromLinkForm.new _add_happening_from_link_form_params
    if @add_happening_from_link_form.save
      @happening = @add_happening_from_link_form.happening
      partial = 'new_form'
    else
      flash.now[:alert] = @add_happening_from_link_form.errors.full_messages.to_sentence
      partial = 'new_from_link'
    end
    render js: _replace_remote_form_with_partial(partial) + %(
      window.dispatchEvent(new Event('resize'));
    )
  end

  # JS
  def create
    authorize!
    @happening = Happening.new
    update_and_render_or_redirect_in_js @happening, _happening_params, ->(happening) { happening_path(happening) }, 'new_form'
  end

  # JS
  def update
    authorize! @happening
    update_and_render_or_redirect_in_js @happening, _happening_params, nil, 'edit_form'
  end

  def destroy
    authorize! @happening
    @happening.destroy!
    redirect_to happenings_path, notice: helpers.t_notice('successfully_deleted', Happening)
  end

  def _set_happening
    @happening = Happening.find params[:id]
  end

  def _happening_params
    params.require(:happening).permit(
      *Happening::FIELDS, :existing_or_new_club, :existing_or_new_venue,
      venue_attributes: Venue::FIELDS,
      club_attributes: Club::FIELDS,
      links_attributes: Link::FIELDS,
      discipline_happenings_attributes: DisciplineHappening::FIELDS + [
        discipline_attributes: Discipline::FIELDS,
      ],
    )
  end

  def _search_happenings_params
    params.require(:search_happenings).permit(
      :venue_id, :activity_id
    )
  end

  def _add_happening_from_link_form_params
    params.require(:add_happening_from_link_form).permit(
      *AddHappeningFromLinkForm::FIELDS
    )
  end
end
