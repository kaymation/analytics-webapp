class CreateFoodMenus < ActiveRecord::Migration
  def change
    create_table :food_menus do |t|
      t.integer :restaurant_id

      t.timestamps
    end
  end
end
