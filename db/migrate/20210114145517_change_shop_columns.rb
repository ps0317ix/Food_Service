class ChangeShopColumns < ActiveRecord::Migration[5.2]
  def change
    remove_column :shops, :lat, :integer
    remove_column :shops, :lng, :integer
    add_column :shops, :latitude, :float
    add_column :shops, :longitude, :float
  end
end
