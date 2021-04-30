class TableLess < ApplicationRecord
  self.abstract_class = true

  def self.load_schema!
    @columns_hash ||= {}

    # From active_record/attributes.rb
    attributes_to_define_after_schema_loads.each do |name, (type, options)|
      type = ActiveRecord::Type.lookup(type, **options.except(:default)) if type.is_a?(Symbol)

      define_attribute(name, type, **options.slice(:default))

      # Improve Model#inspect output
      @columns_hash[name.to_s] = ActiveRecord::ConnectionAdapters::Column.new(name.to_s, options[:default])
    end
  end
end
