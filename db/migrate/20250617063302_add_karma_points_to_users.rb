class AddKarmaPointsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :karma_points, :integer, default: 0
  end
end
