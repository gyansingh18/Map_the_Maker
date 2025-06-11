class Fixthings < ActiveRecord::Migration[7.1]
  def change
    rename_column :reviews, :commment, :comment
    remove_column :makers, :category
    add_column :makers, :categories, :string, array: true
  end
end
