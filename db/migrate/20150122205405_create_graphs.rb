class CreateGraphs < ActiveRecord::Migration
  def change
    create_table :graphs do |t|
      t.string :tags, array: true, default: []
      t.string :body

      t.timestamps
    end
  end
end
