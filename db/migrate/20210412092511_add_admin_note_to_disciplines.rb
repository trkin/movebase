class AddAdminNoteToDisciplines < ActiveRecord::Migration[6.1]
  def change
    add_column :disciplines, :admin_note, :text
  end
end
