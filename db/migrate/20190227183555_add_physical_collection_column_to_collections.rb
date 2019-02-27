class AddPhysicalCollectionColumnToCollections < ActiveRecord::Migration[5.2]
  def change
    add_column :collections, :physical_collection_url, :string
  end
end
