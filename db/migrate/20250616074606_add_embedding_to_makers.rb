class AddEmbeddingToMakers < ActiveRecord::Migration[7.1]
  def change
    add_column :makers, :embedding, :vector, limit: 1536
  end
end
