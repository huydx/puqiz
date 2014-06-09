class AddFieldsToCredit < ActiveRecord::Migration
  def change
    add_column :credits, :username, :string
    add_column :credits, :provider, :string
    add_column :credits, :email, :string
    add_column :credits, :question_number, :integer
  end
end
