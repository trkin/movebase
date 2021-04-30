# rubocop:disable Layout/LineLength
class TranslationsDatatable < BaseDatatable
  def columns
    {
      'translations.translateable_id': {},
      'translations.translateable_type': {hide: true},
      'translations.column_name': {},
      'string_calculated_in_db.column_value_translated': {search: false, title: @view.t('activerecord.attributes.translation.column_value_translated')},
      'translations.column_value': {},
      '': {title: @view.t('actions')},
    }
  end

  def all_items
    model = @view.params[:model].constantize
    column = @view.params[:column]
    sql = <<~SQL.squish
      (SELECT '#{model}' AS translateable_type, id AS translateable_id, '#{column}' AS column_name, #{column} AS column_value, #{column}->'#{I18n.locale}' as column_value_translated FROM #{model.table_name}) as translations
    SQL
    Translation.from([Arel.sql(sql)])
  end

  def rows(filtered)
    filtered.map do |translation|
      edit_link = @view.button_tag_open_modal(
        @view.edit_translation_path(translation.translateable_id, translateable_type: translation.translateable_type, column_name: translation.column_name), title: @view.t_crud('edit', Translation)
      )
      [
        @view.link_to(translation.translateable, translation.translateable),
        translation.translateable_type,
        translation.column_name,
        translation.column_value_translated,
        translation.column_value,
        edit_link,
      ]
    end
  end
end
# rubocop:enable Layout/LineLength
