class CreateUserReports < ActiveRecord::Migration
  def change
    create_table :user_reports do |t|
      t.string :username
      t.string :provider
      t.integer :question_id
      t.string :content

      t.timestamps
    end
  end
end
