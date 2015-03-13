class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.integer :device
      t.integer :preptime
      t.integer :restaurant_id
      t.integer :user_id

      t.timestamps
    end
  end
end
