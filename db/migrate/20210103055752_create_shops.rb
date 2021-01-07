class CreateShops < ActiveRecord::Migration[5.2]
  def change
    create_table :shops do |t|
      t.string :name
      t.string :area
      t.string :url
      t.string :service
      t.string :img
      t.string :jenre

      t.timestamps
    end
  end
end
