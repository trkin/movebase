class CreateRequirements < ActiveRecord::Migration[6.0]
  def change
    create_table :requirements, id: :uuid do |t|
      t.integer :kind
      t.jsonb :name, default: {}
      t.jsonb :description, default: {}

      t.timestamps
    end
  end
end
