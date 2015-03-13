class ChangeReports < ActiveRecord::Migration
  def change
  	add_column :reports, :preptime, :integer
  	add_column :reports, :item, :integer, default: nil
  	add_column :reports, :modifier, :integer, default: nil
  	remove_column :reports, :value
  	remove_column :reports, :date

  end
end
