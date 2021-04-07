class CreateDisciplineAssociations < ActiveRecord::Migration[6.1]
  def change
    create_table :discipline_associations, id: :uuid do |t|
      t.references :discipline, foreign_key: true, null: false, type: :uuid
      t.references :associated, foreign_key: { to_table: :disciplines }, null: false, type: :uuid
      t.integer :kind, null: false, default: 0


      t.timestamps
    end
  end
end
