class AddHtmlContentToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :html_content, :string
  end
end
