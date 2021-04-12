class AddGoogleMapLinkToVenues < ActiveRecord::Migration[6.1]
  def change
    add_column :venues, :google_map_link, :string
  end
end
