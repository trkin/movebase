class CreateClubUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :club_users, id: :uuid do |t|
      t.references :club, foreign_key: true, type: :uuid, null: false
      t.references :user, foreign_key: true, type: :uuid, null: false
      t.integer :status, default: 0, null: false
      t.boolean :admin, default: 0, null: false

      t.timestamps
    end

    add_index :club_users, [:club_id, :user_id], unique: true
  end
end
