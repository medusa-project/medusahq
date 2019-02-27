class AddPrivateDescriptionColumnToCollections < ActiveRecord::Migration[5.2]
  def change
    add_column :collections, :private_description, :text
  end
end
