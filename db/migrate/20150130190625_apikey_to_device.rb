class ApikeyToDevice < ActiveRecord::Migration
  def change
  	add_column :devices, :api_key, :string
  end
end
