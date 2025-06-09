class CreateMakers < ActiveRecord::Migration[7.1]
  def change
    create_table :makers do |t|
      t.string :name
      t.string :location
      t.text :description
      t.text :category
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
