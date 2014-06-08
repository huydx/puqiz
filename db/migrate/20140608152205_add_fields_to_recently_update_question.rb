class AddFieldsToRecentlyUpdateQuestion < ActiveRecord::Migration
  def change
    add_column :recently_update_questions, :tag_id, :integer
    add_column :recently_update_questions, :question_id, :integer
  end
end
