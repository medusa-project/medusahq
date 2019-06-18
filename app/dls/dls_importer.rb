class DlsImporter

  attr_accessor :client

  def initialize
    self.client = DlsClient.instance
  end

  def import_collections
    puts "Importing DLS collection information"
    progress_bar = ProgressBar.new(Collection.count)
    Collection.all.each do |collection|
      import_collection(collection)
      progress_bar.increment!
    end
  end

  def import_collection(collection)
    #try to get collection json - note that not all collections are in DLS, so an attempt may fail -
    # we get a 403 in this case
    # if successful, update collection with appropriate data from the JSON
    response = client.get(collection_path(collection))
    case response.status
    when 200
      update_collection(collection, JSON.parse(response.body))
    when 403
      #puts "Skipping unpublished or unknown collection uuid: #{collection.uuid}"
    else
      raise "Unexpected response from DLS server: #{response.code}. Collection UUID: #{collection.uuid}"
    end
  end

  def update_collection(collection, dls_hash)
    collection.published_in_dls = dls_hash['published']
    collection.medusa_cfs_directory_id = dls_hash['medusa_cfs_directory_id']
    collection.medusa_file_group_id = dls_hash['medusa_file_group_id']
    collection.rightsstatements_org_uri = dls_hash['rightsstatements_org_uri']
    collection.package_profile = dls_hash['package_profile']
    collection.save!
  end

  def collection_path(collection)
    "/collections/#{collection.uuid}.json"
  end

  def collection_admin_path(collection)
    "/admin" + collection_path(collection)
  end

end