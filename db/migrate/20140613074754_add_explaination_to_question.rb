class AddExplainationToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :explaination, :string, :limit => 2000
    add_column :questions, :explaination_html_content, :string, :limit => 3000
  end
end
