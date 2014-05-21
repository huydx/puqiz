class ChangeFlagAnswerToInt < ActiveRecord::Migration
  def change
    change_column :answers, :flag, :int
  end
end
