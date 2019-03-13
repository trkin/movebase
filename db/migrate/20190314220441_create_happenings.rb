class CreateHappenings < ActiveRecord::Migration[6.0]
  def change
    create_table :happenings, id: :uuid do |t|
      t.references :venue, foreign_key: true, null: false, type: :uuid
      t.references :club, foreign_key: true, type: :uuid
      t.jsonb :name, default: {}
      t.date :start_date
      t.date :end_date
      t.string :website
      t.integer :repeating, default: 0, null: false

      t.timestamps
    end
  end
end
