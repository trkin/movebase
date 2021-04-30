# rubocop:disable Layout/LineLength
class TranslationsDatatable < BaseDatatable
  def columns
    {
      'translations.translateable_id': {},
      'translations.translateable_type': {hide: true},
      'translations.column_name': {},
      'translations.column_value': {},
      '': {},
    }
  end

  def all_items
    sql = <<~SQL.squish
      (
        (SELECT 'Activity' AS translateable_type, id AS translateable_id, 'name' AS column_name, name AS column_value FROM activities)
        UNION
        (SELECT 'Activity' AS translateable_type, id AS translateable_id, 'description' AS column_name, description AS column_value FROM activities)
      ) as translations
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
        translation.column_value,
        edit_link,
      ]
    end
  end
end
# rubocop:enable Layout/LineLength
