class CreateActivityClubs < ActiveRecord::Migration[6.0]
  def change
    create_table :activity_clubs, id: :uuid do |t|
      t.references :activity, null: false, foreign_key: true, type: :uuid
      t.references :club, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
