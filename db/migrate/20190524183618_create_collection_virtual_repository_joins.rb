class CreateCollectionVirtualRepositoryJoins < ActiveRecord::Migration[5.2]
  def change
    create_table :collection_virtual_repository_joins do |t|
      t.integer :collection_id, null: false
      t.integer :virtual_repository_id, null: false
    end
    add_index :collection_virtual_repository_joins, [:virtual_repository_id, :collection_id], unique: true,
              name: :collection_virtual_repository_joins_on_both_ids
    add_index :collection_virtual_repository_joins, :collection_id, name: :collection_virtual_repository_joins_on_c_id
  end
end
