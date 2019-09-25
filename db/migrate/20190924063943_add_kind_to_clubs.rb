class AddKindToClubs < ActiveRecord::Migration[6.0]
  def change
    add_column :clubs, :kind, :integer, default: 0, null: false
    remove_column :clubs, :personal, :boolean
    change_column_null :happenings, :club_id, false
    change_column_null :clubs, :venue_id, true
  end
end
