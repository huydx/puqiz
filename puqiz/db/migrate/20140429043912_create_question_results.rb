class CreateQuestionResults < ActiveRecord::Migration
  def change
    create_table :question_results do |t|
      t.integer :question_id
      t.integer :user_id
      t.string :result

      t.timestamps
    end
  end
end
