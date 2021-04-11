class AddPositionToDisciplineHappenings < ActiveRecord::Migration[6.1]
  def change
    add_column :discipline_happenings, :position, :integer
  end
end
