class CreateAccessSystemCollectionJoins < ActiveRecord::Migration[5.2]
  def change
    create_table :access_system_collection_joins do |t|
      t.references :collection, foreign_key: true
      t.references :access_system, foreign_key: true
    end
    add_index :access_system_collection_joins, [:collection_id, :access_system_id], unique: true,
              name: :index_access_system_collection_joins_on_both_ids
  end
end
