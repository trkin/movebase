class CreateTags < ActiveRecord::Migration[6.0]
  def change
    create_table :tags, id: :uuid do |t|
      t.jsonb :name, default: {}
      t.integer :kind

      t.timestamps
    end
  end
end
