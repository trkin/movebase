class RemoveUnusedColumns < ActiveRecord::Migration[6.0]
  def change
    remove_column :clubs, :website
    remove_column :clubs, :long_name
    remove_column :clubs, :email
    remove_column :clubs, :phone
    remove_column :clubs, :national_id
    remove_column :clubs, :visible_email
    remove_column :clubs, :visible_phone
    remove_column :clubs, :visible_national_id
    remove_column :clubs, :logo_url
  end
end
