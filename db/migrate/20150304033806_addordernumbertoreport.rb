class Addordernumbertoreport < ActiveRecord::Migration
  def change
  	add_column :reports, :order_number, :integer
  end
end
