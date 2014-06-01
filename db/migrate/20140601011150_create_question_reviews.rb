class CreateQuestionReviews < ActiveRecord::Migration
  def change
    create_table :question_reviews do |t|
      t.string :content
      t.integer :tag_id
      t.integer :level
      t.integer :time
      t.string :url

      t.timestamps
    end
  end
end
