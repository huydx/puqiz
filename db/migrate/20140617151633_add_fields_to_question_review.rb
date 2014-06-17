class AddFieldsToQuestionReview < ActiveRecord::Migration
  def change
    add_column :question_reviews, :explaination, :string, :limit => 2000
    add_column :question_reviews, :explaination_html_content, :string, :limit => 3000
    add_column :question_reviews, :explaination_url, :string, :limit => 2000
  end
end
