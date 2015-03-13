class CreateActivityLogs < ActiveRecord::Migration
  def change
    create_table :activity_logs do |t|
      t.integer :device_id
      t.integer :preptime
      t.integer :item
      t.string :modifier
      t.integer :order_number

      t.timestamps
    end
  end
end
