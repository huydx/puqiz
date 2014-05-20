class AddIndexToQuestionResult < ActiveRecord::Migration
  def change
    add_index :question_results, :question_id
    add_index :question_results, :user_id
  end
end
