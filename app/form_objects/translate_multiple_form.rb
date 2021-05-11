class TranslateMultipleForm
  include ActiveModel::Model

  FIELDS = %i[column_name from_locale to_locale].freeze
  attr_accessor :records, *FIELDS
  attr_reader :message

  validates(*FIELDS, presence: true)

  def save # rubocop:todo Metrics/MethodLength
    already_exists = 0
    blank_source = 0
    successfully_translated = 0
    records.each do |record|
      current_value = record.send("#{column_name}_backend").read(to_locale, fallback: false)
      if current_value.present?
        already_exists += 1
        next
      end

      from_value = record.send("#{column_name}_backend").read(from_locale, fallback: false)
      if from_value.blank?
        blank_source += 1
        next
      end

      translation = GoogleTranslate.new(from_value, from_locale: from_locale, to_locale: to_locale).perform
      translate_form = TranslateForm.new(record: record, column_name: column_name, locale: to_locale, column_value: translation)
      successfully_translated += 1 if translate_form.save
    end
    @message = I18n.t(
      'already_exists_count_blank_source_count_successfully_translated_count',
      already_exists_count: already_exists,
      blank_source_count: blank_source,
      successfully_translated_count: successfully_translated
    )
  end
end
