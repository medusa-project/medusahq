class RenameRepositoryIdToUuidOnCollections < ActiveRecord::Migration[5.2]
  def change
    rename_column :collections, :repository_id, :uuid
  end
end
