class CreateDegrees < ActiveRecord::Migration
  def change
    create_table :degrees do |t|
      t.integer :user_id
      t.integer :tag_id
      t.integer :type

      t.timestamps
    end
  end
end
