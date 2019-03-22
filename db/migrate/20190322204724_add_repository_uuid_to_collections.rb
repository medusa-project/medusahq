class AddRepositoryUuidToCollections < ActiveRecord::Migration[5.2]
  def change
    add_column :collections, :repository_uuid, :string
  end
end
