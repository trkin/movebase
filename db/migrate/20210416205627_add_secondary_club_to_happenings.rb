class AddSecondaryClubToHappenings < ActiveRecord::Migration[6.1]
  def change
    add_reference :happenings, :secondary_club, null: true, foreign_key: { to_table: :clubs }, type: :uuid
  end
end
