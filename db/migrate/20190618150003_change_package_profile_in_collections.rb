class ChangePackageProfileInCollections < ActiveRecord::Migration[5.2]
  def change
    remove_column :collections, :package_profile_id
    add_column :collections, :package_profile, :string
  end
end
