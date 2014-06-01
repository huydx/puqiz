class CreateAnswerReviews < ActiveRecord::Migration
  def change
    create_table :answer_reviews do |t|
      t.string :content
      t.integer :flag
      t.integer :question_review_id

      t.timestamps
    end
  end
end
