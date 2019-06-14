class DlsImporter

  attr_accessor :client

  def initialize
    self.client = DlsClient.instance
  end

  def import_collections
    Collection.all.each do |collection|
      import_collection(collection)
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
      puts "Skipping unpublished or unknown collection uuid: #{collection.uuid}"
    else
      raise "Unexpected response from DLS server: #{response.code}. Collection UUID: #{collection.uuid}"
    end
  end

  def update_collection(collection, dls_hash)
    #TODO - whatever we need to here to update collection
    puts "Importing collection uuid: #{collection.uuid}"
  end

  def collection_path(collection)
    "/collections/#{collection.uuid}.json"
  end

  def collection_admin_path(collection)
    "/admin" + collection_path(collection)
  end

end