class AddRestidAndUserIDtoGraph < ActiveRecord::Migration
  def change
  	add_column :graphs, :restaurant_id, :integer
  	add_column :graphs, :user_id, :integer
  end
end
