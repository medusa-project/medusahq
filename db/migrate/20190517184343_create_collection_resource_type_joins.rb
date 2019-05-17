class CreateCollectionResourceTypeJoins < ActiveRecord::Migration[5.2]
  def change
    create_table :collection_resource_type_joins do |t|
      t.references :collection, foreign_key: true
      t.references :resource_type, foreign_key: true
    end
    add_index :collection_resource_type_joins, [:collection_id, :resource_type_id], unique: true,
              name: :index_collection_resource_type_joins_on_both_ids
  end
end
