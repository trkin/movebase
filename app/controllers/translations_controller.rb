class TranslationsController < ApplicationController
  before_action do
    authorize! Object, to: :translations?, with: AdminPolicy
  end

  before_action :_set_json_columns, only: %i[index search update_multiple]

  def index
    @datatable = TranslationsDatatable.new view_context
  end

  def search
    render json: TranslationsDatatable.new(view_context)
  end

  def edit
    klass = params[:model].constantize
    record = klass.find params[:id]
    @translate_form = TranslateForm.new(record: record, column_name: params[:column_name])
    render partial: 'form', layout: false
  end

  # JS
  def update
    klass = params[:model].constantize
    record = klass.find params[:id]
    @translate_form = TranslateForm.new(record: record, column_name: params[:column_name])
    update_and_render_or_redirect_in_js @translate_form, _translate_form_params, translations_path
  end

  def update_multiple
    klass = params[:model].constantize
    records = klass.where id: params[:record_ids]
    translate_multiple_form = TranslateMultipleForm.new(
      column_name: params[:column_name], records: records, from_locale:
      params[:from_locale], to_locale: params[:to_locale]
    )
    if translate_multiple_form.save
      flash[:notice] = translate_multiple_form.message
    else
      flash[:alert] = translate_multiple_form.errors.full_messages.to_sentence
    end
    redirect_to translations_path(params.to_unsafe_h.slice(:model, :column_name, :from_locale, :to_locale))
  end

  def _translate_form_params
    params.require(:translate_form).permit(
      *TranslateForm::FIELDS
    )
  end

  def _translate_multiple_form_params
    params.permit(
      *TranslateMultipleForm::FIELDS
    )
  end

  def _set_json_columns
    unless TranslationsDatatable::CLASSES.map(&:name).include?(params[:model])
      redirect_to translations_path(model: 'Activity', column_name: 'name') and return
    end

    @klass = params[:model].constantize
    @json_columns = @klass.columns.select { |column| column.type == :jsonb }.map(&:name)
    return if @json_columns.include?(params[:column_name])

    redirect_to translations_path(model: params[:model], column_name: @json_columns.first)
  end
end
