class AddAccumulatePointToDegree < ActiveRecord::Migration
  def change
    add_column :degrees, :accumulate_point, :integer
  end
end
