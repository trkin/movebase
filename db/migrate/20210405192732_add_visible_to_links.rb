class AddVisibleToLinks < ActiveRecord::Migration[6.0]
  def change
    add_column :links, :visible, :boolean, default: true, null: false
    remove_column :happenings, :website
  end
end
