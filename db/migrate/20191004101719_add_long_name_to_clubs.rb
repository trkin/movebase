class AddLongNameToClubs < ActiveRecord::Migration[6.0]
  def change
    add_column :clubs, :long_name, :jsonb, after: :name, default: {}
    add_column :happenings, :description, :jsonb, default: {}
    add_column :discipline_happenings, :description, :jsonb, default: {}

    remove_column :happenings, :repeating, :integer, default: 0
    add_column :happenings, :recurrence, :string
  end
end
