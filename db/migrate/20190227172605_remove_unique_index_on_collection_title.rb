class RemoveUniqueIndexOnCollectionTitle < ActiveRecord::Migration[5.2]
  def change
    remove_index :collections, :title # remove the unique index
    add_index :collections, :title # add a new non-unique index
  end
end
