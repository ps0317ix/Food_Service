class CreatePlaces < ActiveRecord::Migration[5.2]
  def change
    create_table :places do |t|
      t.string :area
      t.string :url
      t.string :service

      t.timestamps
    end
  end
end
