class AddColumnShop < ActiveRecord::Migration[5.2]
  def change
    add_column :shops, :lat, :integer
    add_column :shops, :lng, :integer
  end
end
