class ChangePointToInt < ActiveRecord::Migration
  def change
    change_column :users, :point, :integer
  end
end
