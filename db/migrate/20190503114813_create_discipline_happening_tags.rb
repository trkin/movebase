class CreateDisciplineHappeningTags < ActiveRecord::Migration[6.0]
  def change
    create_table :discipline_happening_tags, id: :uuid do |t|
      t.references :discipline_happening, foreign_key: true, null: false, type: :uuid
      t.references :tag, foreign_key: true, null: false, type: :uuid

      t.timestamps
    end
  end
end
