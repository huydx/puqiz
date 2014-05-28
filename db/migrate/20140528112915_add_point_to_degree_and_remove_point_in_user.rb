class AddPointToDegreeAndRemovePointInUser < ActiveRecord::Migration
  def change
    add_column :degrees, :point, :integer
    remove_column :users, :point
  end
end
