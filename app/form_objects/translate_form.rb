class TranslateForm
  include ActiveModel::Model

  def self.underscored_locales
    I18n.available_locales.map(&:to_s).map(&:underscore)
  end

  FIELDS = [:column_name, *underscored_locales].freeze
  attr_accessor :record, *FIELDS

  def initialize(attributes)
    super

    self.class.underscored_locales.each do |locale|
      send "#{locale}=", record.send("#{column_name}_backend").read(locale.tr('_', '-'))
    end
  end

  def save
    self.class.underscored_locales.each do |locale|
      record.send("#{column_name}_backend").write(locale.tr('_', '-'), send(locale))
    end
    record.save!
    true
  end

  def new_record?
    false
  end
end
