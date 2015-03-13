class UpdateRestaurants < ActiveRecord::Migration
  def change
  	add_column :restaurants, :food_menu_id, :integer
  	add_column :restaurants, :location_info, :string
  	
  end
end
