class CreateLeagues < ActiveRecord::Migration[6.1]
  def change
    create_table :leagues, id: :uuid do |t|
      t.jsonb :name, default: {}
      t.references :parent_league, foreign_key: true, type: :uuid, foreign_key: { to_table: :leagues }

      t.timestamps
    end
  end
end
