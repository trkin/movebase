class AddLogoUrlToClubs < ActiveRecord::Migration[6.0]
  def change
    add_column :clubs, :logo_url, :string
  end
end
