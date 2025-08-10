class CreateReviewProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :review_products do |t|
      t.references :product, null: false, foreign_key: true
      t.references :review, null: false, foreign_key: true

      t.timestamps
    end
  end
end
