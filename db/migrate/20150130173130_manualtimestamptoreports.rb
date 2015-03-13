class Manualtimestamptoreports < ActiveRecord::Migration
  def change
  	 	add_column :reports, :when, :datetime
  end
end
