class Fixdevcolumnanem < ActiveRecord::Migration
  def change
  	rename_column :reports, :device, :device_id
  end
end
