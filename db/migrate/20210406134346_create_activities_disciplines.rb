class CreateActivitiesDisciplines < ActiveRecord::Migration[6.1]
  def change
    create_table :activities_disciplines, id: false do |t|
      t.references :activity, null: false, foreign_key: true, type: :uuid
      t.references :discipline, null: false, foreign_key: true, type: :uuid
    end
  end
end
