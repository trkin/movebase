class DropActivityAssociations < ActiveRecord::Migration[6.1]
  def change
    drop_table :activity_associations
    remove_reference :disciplines, :activity
  end
end
