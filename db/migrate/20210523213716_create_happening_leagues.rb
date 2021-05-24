class CreateHappeningLeagues < ActiveRecord::Migration[6.1]
  def change
    create_table :happening_leagues, id: :uuid do |t|
      t.references :happening, null: false, foreign_key: true, type: :uuid
      t.references :league, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
