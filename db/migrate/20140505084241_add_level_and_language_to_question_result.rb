class AddLevelAndLanguageToQuestionResult < ActiveRecord::Migration
  def change
    add_column :question_results, :tag_id, :string
    add_column :question_results, :level, :integer
  end
end
