class CreateDisciplineRequirements < ActiveRecord::Migration[6.0]
  def change
    create_table :discipline_requirements, id: :uuid do |t|
      t.references :discipline, foreign_key: true, null: false, type: :uuid
      t.references :requirement, foreign_key: true, null: false, type: :uuid

      t.timestamps
    end
  end
end
