class AddExplainationUrlToTag < ActiveRecord::Migration
  def change
    add_column :tags, :explaination_url, :string
  end
end
