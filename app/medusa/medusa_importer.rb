class MedusaImporter

  COLLECTIONS_PATH = '/collections.json'
  REPOSITORIES_PATH = '/repositories.json'
  def import(print_progress = false)
    start_time = Time.now
    client = MedusaClient.instance

    import_repositories(client, print_progress, start_time)
    import_collections(client, print_progress, start_time)
  end

  private

  #a little bit easier than collections, since the index exports all the relevant information
  def import_repositories(client, print_progress, start_time)
    raw_response = client.get(REPOSITORIES_PATH)
    #array of objects
    json_repositories = JSON.parse(raw_response.json)
    json_repositories.each.with_index do |json_repository, index|
      repository = Repository.find_by(uuid: json_repository['uuid']) || Repository.new
      fields = %w(uuid title url notes address_1 address_2 city state zip phone_number email contact_email ldap_admin_group)
      fields.each do |field|
        repository.send("#{field}=", json_repository[field])
      end
      repository.save!
      if print_progress
        StringUtils.print_progress(start_time, index, json_repositories.length,
                                   'Importing Repositories from Medusa')
      end
    end
  end

  def import_collections(client, print_progress, start_time)
    list_response = client.get(COLLECTIONS_PATH)
    list_struct = JSON.parse(list_response.body)
    list_struct.each_with_index do |mc, index|
      show_path = mc['path']
      show_response = client.get(show_path + '.json')
      show_struct = JSON.parse(show_response.body)
      c = Collection.find_by(uuid: show_struct['uuid']) || Collection.new
      c.uuid = show_struct['uuid']
      c.title = show_struct['title']
      c.description = show_struct['description']
      c.description_html = show_struct['description_html']
      c.private_description = show_struct['private_description'] # TODO: this doesn't exist
      c.access_url = show_struct['access_url']
      c.physical_collection_url = show_struct['physical_collection_url']
      c.external_id = show_struct['external_id']
      c.published = show_struct['publish']
      c.representative_image_id = show_struct['representative_image']
      c.representative_item_id = show_struct['representative_item']
      c.external_id = show_struct['external_id']
      c.repository_uuid = show_struct['repository_uuid']
      c.save!
      if print_progress
        StringUtils.print_progress(start_time, index, list_struct.length,
                                   'Importing Collecions from Medusa')
      end
    end
  end

end