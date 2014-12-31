class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.integer :device
      t.date :date
      t.integer :value
      t.integer :restaurant_id
      t.integer :user_id

      t.timestamps
    end
  end
end
