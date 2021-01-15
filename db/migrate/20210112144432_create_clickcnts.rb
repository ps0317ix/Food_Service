class CreateClickcnts < ActiveRecord::Migration[5.2]
  def change
    create_table :clickcnts do |t|
      t.integer :click

      t.timestamps
    end
  end
end
