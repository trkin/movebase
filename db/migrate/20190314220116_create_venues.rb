class CreateVenues < ActiveRecord::Migration[6.0]
  def change
    create_table :venues, id: :uuid do |t|
      t.jsonb :name, default: {}
      t.float :latitude
      t.float :longitude
      t.string :address
      t.string :city
      t.string :state
      t.string :country
      t.string :zip

      t.timestamps
    end
  end
end
