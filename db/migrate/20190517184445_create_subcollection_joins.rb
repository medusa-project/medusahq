class CreateSubcollectionJoins < ActiveRecord::Migration[5.2]
  def change
    create_table :subcollection_joins do |t|
      t.integer :parent_collection_id, null: false, index: true
      t.integer :child_collection_id, null: false, index: true
    end
    add_index :subcollection_joins, [:parent_collection_id, :child_collection_id], unique: true,
              name: :index_subcollection_joins_on_both_ids
  end
end
