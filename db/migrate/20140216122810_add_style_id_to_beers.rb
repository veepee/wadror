class AddStyleIdToBeers < ActiveRecord::Migration
  def change
    add_column :beers, :style_id, :integer
  end
end
