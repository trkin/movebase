class AddVisibleColumnsToClubs < ActiveRecord::Migration[6.0]
  def change
    add_column :clubs, :visible_email, :boolean
    add_column :clubs, :visible_phone, :boolean
    add_column :clubs, :visible_national_id, :boolean
  end
end
