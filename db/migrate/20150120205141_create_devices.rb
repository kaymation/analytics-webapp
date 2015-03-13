class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :station_name
      t.string :error_logs
      t.integer :configuration_profile_id
      t.string :license
      t.integer :restaurant_id

      t.timestamps
    end
  end
end
