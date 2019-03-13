class CreateActivityAssociations < ActiveRecord::Migration[6.0]
  def change
    create_table :activity_associations, id: :uuid do |t|
      t.references :activity, foreign_key: true, null: false, type: :uuid
      t.references :associated, foreign_key: { to_table: :activities }, null: false, type: :uuid
      t.integer :kind, null: false, default: 0

      t.timestamps
    end
  end
end
