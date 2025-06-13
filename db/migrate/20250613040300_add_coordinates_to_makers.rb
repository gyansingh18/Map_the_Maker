class AddCoordinatesToMakers < ActiveRecord::Migration[7.1]
  def change
    add_column :makers, :latitude, :float
    add_column :makers, :longitude, :float
  end
end
