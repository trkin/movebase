class CreateLinks < ActiveRecord::Migration[6.0]
  def change
    create_table :links, id: :uuid do |t|
      t.references :linkable, polymorphic: true, null: false, type: :uuid
      t.string :kind, null: false
      t.string :url, null: false

      t.timestamps
    end
  end
end
