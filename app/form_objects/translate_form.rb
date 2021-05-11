class TranslateForm
  include ActiveModel::Model

  FIELDS = %i[column_name locale column_value].freeze
  attr_accessor :record, *FIELDS

  def initialize(attributes)
    super

    self.locale ||= I18n.locale
    self.column_value ||= record.send("#{column_name}_backend").read(locale)
  end

  def save
    record.send("#{column_name}_backend").write(locale, column_value)
    record.save!
    true
  end

  def new_record?
    false
  end
end
