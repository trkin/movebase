class ActivitiesController < ApplicationController
  before_action :_set_activity, except: %i[index new create]

  def index
    @datatable = ActivitiesDatatable.new view_context
  end

  def search
    render json: ActivitiesDatatable.new(view_context)
  end

  def show; end

  def new
    @activity = Activity.new
    render partial: 'form', layout: false
  end

  def edit
    render partial: 'form', layout: false
  end

  # JS
  def create
    @activity = Activity.new
    update_and_render_or_redirect_in_js @activity, _activity_params, ->(activity) { activity_path(activity) }
  end

  # JS
  def update
    update_and_render_or_redirect_in_js @activity, _activity_params, activity_path(@activity)
  end

  def destroy
    @activity.destroy!
    redirect_to activities_path, notice: helpers.t_notice('successfully_deleted', Activity)
  end

  def _set_activity
    @activity = Activity.find params[:id]
  end

  def _activity_params
    params.require(:activity).permit(
      *Activity::FIELDS
    )
  end
end
