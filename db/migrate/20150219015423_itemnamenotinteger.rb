class Itemnamenotinteger < ActiveRecord::Migration
  def change
  	remove_column :reports, :item 
  	add_column :reports, :item, :string
  end
end
