class AddAdminNotesToActivities < ActiveRecord::Migration[6.1]
  def change
    add_column :activities, :admin_notes, :text
  end
end
