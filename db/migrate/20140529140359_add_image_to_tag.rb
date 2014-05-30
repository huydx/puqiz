class AddImageToTag < ActiveRecord::Migration
  def change
    add_column :tags, :image, :string
  end
end
