class Translation < TableLess
  self.table_name = :translations
  attribute :translateable_type, :string, default: nil
  attribute :translateable_id, :string, default: nil
  attribute :column_name, :string, default: nil
  attribute :column_value, :string, default: nil

  belongs_to :translateable, polymorphic: true
end
