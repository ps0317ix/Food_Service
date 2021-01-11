class Shop < ActiveRecord::Migration[5.2]
  def change
    add_column :shops, :address, :string
    remove_column :places, :address, :string
  end
end
