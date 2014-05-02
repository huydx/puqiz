class AddFieldsToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :level, :string
    add_column :questions, :time, :integer
  end
end
