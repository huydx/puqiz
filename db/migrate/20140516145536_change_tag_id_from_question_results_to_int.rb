class ChangeTagIdFromQuestionResultsToInt < ActiveRecord::Migration
  def change
    change_column :question_results, :tag_id, :integer
  end
end
