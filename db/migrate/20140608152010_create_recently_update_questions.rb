class CreateRecentlyUpdateQuestions < ActiveRecord::Migration
  def change
    create_table :recently_update_questions do |t|

      t.timestamps
    end
  end
end
