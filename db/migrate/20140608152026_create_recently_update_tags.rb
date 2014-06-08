class CreateRecentlyUpdateTags < ActiveRecord::Migration
  def change
    create_table :recently_update_tags do |t|

      t.timestamps
    end
  end
end
