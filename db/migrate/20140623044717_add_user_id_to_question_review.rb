class AddUserIdToQuestionReview < ActiveRecord::Migration
  def change
    add_column :question_reviews, :user_id, :integer
    add_column :questions, :user_id, :integer
  end
end
