class CreateUserRoles < ActiveRecord::Migration[6.1]
  def change
    create_table :user_roles, id: :uuid do |t|
      t.references :user, foreign_key: true, type: :uuid, null: false
      t.string :role, default: 'default', null: false
      t.references :user_rolable, polymorphic: true

      t.timestamps
    end
  end
end
