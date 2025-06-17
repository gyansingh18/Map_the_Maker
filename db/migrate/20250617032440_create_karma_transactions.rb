class CreateKarmaTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :karma_transactions do |t|
      t.integer :points_awarded
      t.references :user, null: false, foreign_key: true
      t.references :source, polymorphic: true, null: false
      t.timestamps
    end
  end
end
