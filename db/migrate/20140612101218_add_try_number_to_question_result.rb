class AddTryNumberToQuestionResult < ActiveRecord::Migration
  def change
    add_column :question_results, :try_time, :integer
  end
end
