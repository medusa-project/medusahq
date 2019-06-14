class AddDlsFieldsToCollection < ActiveRecord::Migration[5.2]
  def change
    add_column :collections, :descriptive_element_id, :integer
    add_column :collections, :medusa_cfs_directory_id, :integer
    add_column :collections, :medusa_file_group_id, :integer
    add_column :collections, :metadata_profile_id, :integer
    add_column :collections, :package_profile_id, :integer
    add_column :collections, :published_in_dls, :boolean
    add_column :collections, :rightsstatements_org_uri, :string
  end
end
