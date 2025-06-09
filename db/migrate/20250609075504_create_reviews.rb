class CreateReviews < ActiveRecord::Migration[7.1]
  def change
    create_table :reviews do |t|
      t.text :commment
      t.integer :overall_rating
      t.integer :freshness_rating
      t.integer :service_rating
      t.integer :product_range_rating
      t.integer :accuracy_rating
      t.references :user, null: false, foreign_key: true
      t.references :maker, null: false, foreign_key: true

      t.timestamps
    end
  end
end
