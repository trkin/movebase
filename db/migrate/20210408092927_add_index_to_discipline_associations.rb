class AddIndexToDisciplineAssociations < ActiveRecord::Migration[6.1]
  def change
    add_index :discipline_associations, [:associated_id, :discipline_id, :kind], unique: true, name: 'i_discipline_associations_uniq'
    remove_index :discipline_associations, :associated_id
  end
end
