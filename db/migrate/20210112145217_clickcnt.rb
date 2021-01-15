class Clickcnt < ActiveRecord::Migration[5.2]
  def change
    add_column :clickcnts, :shop, :string
    add_column :clickcnts, :area, :string
    add_column :clickcnts, :service, :string
  end
end
