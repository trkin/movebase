class AddPositionToClubUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :club_users, :position, :string
    remove_column :club_users, :status, :integer
  end
end
