class TranslationsController < ApplicationController
  before_action do
    authorize! Object, to: :translations?, with: AdminPolicy
  end

  def index # rubocop:todo Metrics/CyclomaticComplexity
    unless [Activity, Discipline, Club].map(&:name).include?(params[:model])
      redirect_to translations_path(model: 'Activity', column: 'name') and return
    end

    @klass = params[:model].constantize
    @json_columns = @klass.columns.select { |column| column.type == :jsonb }.map(&:name)
    unless @json_columns.include?(params[:column])
      redirect_to translations_path(model: params[:model], column: @json_columns.first) and return
    end

    @datatable = TranslationsDatatable.new view_context
  end

  def search
    render json: TranslationsDatatable.new(view_context)
  end

  def edit
    klass = params[:translateable_type].constantize
    record = klass.find params[:id]
    @translate_form = TranslateForm.new(record: record, column_name: params[:column_name])
    render partial: 'form', layout: false
  end

  # JS
  def update
    klass = params[:translateable_type].constantize
    record = klass.find params[:id]
    @translate_form = TranslateForm.new(record: record, column_name: params[:column_name])
    update_and_render_or_redirect_in_js @translate_form, _translate_form_params, translations_path
  end

  def _translate_form_params
    params.require(:translate_form).permit(
      *TranslateForm::FIELDS
    )
  end
end
