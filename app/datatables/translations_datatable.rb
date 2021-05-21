# rubocop:disable Layout/LineLength
class TranslationsDatatable < BaseDatatable
  CLASSES = [Activity, Club].freeze
  def columns
    {
      'translations.translateable_id': {},
      'translations.translateable_type': { hide: true },
      'translations.column_name': {},
      'string_calculated_in_db.column_value_translated': { search: false, title: @view.t('activerecord.attributes.translation.column_value_translated') },
      'translations.column_value': {},
      '': { title: "<input type='checkbox' data-action='multiple#toggleAll'> #{@view.t('actions')}".html_safe },
    }
  end

  def all_items
    model = @view.params[:model].constantize
    column_name = @view.params[:column_name]
    sql = <<~SQL.squish
      (SELECT '#{model}' AS translateable_type, id AS translateable_id, '#{column_name}' AS column_name, #{column_name} AS column_value, #{column_name}->'#{I18n.locale}' as column_value_translated FROM #{model.table_name}) as translations
    SQL
    Translation.from([Arel.sql(sql)])
  end

  def rows(filtered)
    filtered.map do |translation|
      edit_link = @view.check_box_tag('record_ids[]', translation.translateable_id, false, 'data-action': 'multiple#toggle') +
                  @view.button_tag_open_modal(
                    @view.edit_translation_path(translation.translateable_id, model: translation.translateable_type, column_name: translation.column_name), title: @view.t_crud('edit', Translation), 'data-test': translation.translateable_id
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
