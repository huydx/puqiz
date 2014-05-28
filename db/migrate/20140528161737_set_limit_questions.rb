class SetLimitQuestions < ActiveRecord::Migration
  def change
    change_column :questions, :content, :string, limit: 2000
    change_column :questions, :html_content, :string, limit: 2000
  end
end
