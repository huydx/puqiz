class AddExplainationFieldToTag < ActiveRecord::Migration
  def change
    add_column :tags, :explaination, :string
  end
end
