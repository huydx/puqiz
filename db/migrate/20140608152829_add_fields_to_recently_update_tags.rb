class AddFieldsToRecentlyUpdateTags < ActiveRecord::Migration
  def change
    add_column :recently_update_tags, :tag_id, :integer
  end
end
