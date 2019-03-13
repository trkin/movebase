class CreateClubs < ActiveRecord::Migration[6.0]
  def change
    create_table :clubs, id: :uuid do |t|
      t.references :venue, foreign_key: true, null: false, type: :uuid
      t.jsonb :name, default: {}
      t.string :website
      t.string :email
      t.string :phone
      t.boolean :personal, default: false, null: false
      t.string :national_id

      t.timestamps
    end
  end
end
