class CreateDisciplineHappenings < ActiveRecord::Migration[6.0]
  def change
    create_table :discipline_happenings, id: :uuid do |t|
      t.references :discipline, foreign_key: true, null: false, type: :uuid
      t.references :happening, foreign_key: true, null: false, type: :uuid
      t.jsonb :name, default: {}
      t.integer :gender, default: 0, null: false
      t.integer :distance_m
      t.integer :elevation_m
      t.integer :max_time_s
      t.integer :age_min
      t.integer :age_max
      t.monetize :price_without_discount
      t.datetime :start_time

      t.timestamps
    end
  end
end
