class AddExplainationUrlToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :explaination_url, :string
  end
end
