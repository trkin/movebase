class AddClubToUsers < ActiveRecord::Migration[6.0]
  def change
    add_reference :users, :club, foreign_key: true, type: :uuid
  end
end
