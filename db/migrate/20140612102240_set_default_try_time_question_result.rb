class SetDefaultTryTimeQuestionResult < ActiveRecord::Migration
  def change
    change_column :question_results, :try_time, :integer, :default => 0 
  end
end
