class MedusaImporter

  COLLECTIONS_PATH = '/collections.json'
  REPOSITORIES_PATH = '/repositories.json'
  ACCESS_SYSTEMS_PATH = '/access_systems.json'
  RESOURCE_TYPES_PATH='/resource_types.json'

  def import(print_progress = false)
    start_time = Time.now
    client = MedusaClient.instance

    import_access_systems(client, print_progress, start_time)
    import_resource_types(client, print_progress, start_time)
    import_repositories(client, print_progress, start_time)
    import_collections(client, print_progress, start_time)
  end

  private

  #a little bit easier than collections, since the index exports all the relevant information
  def import_repositories(client, print_progress, start_time)
    raw_response = client.get(REPOSITORIES_PATH)
    #array of objects
    json_repositories = JSON.parse(raw_response.body)
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

  #TODO access systems and resource types
  #TODO parent/child relations
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
      c.medusa_id = show_struct['id']
      c.contact_email = show_struct['contact_email']
      c.save!
      if print_progress
        StringUtils.print_progress(start_time, index, list_struct.length,
                                   'Importing Collections from Medusa')
      end
    end
  end

  def import_access_systems(client, print_progress, start_time)
    raw_response = client.get(ACCESS_SYSTEMS_PATH)
    json_access_systems = JSON.parse(raw_response.body)
    json_access_systems.each.with_index do |json_access_system, index|
      access_system = AccessSystem.find_by(name: json_access_system['name']) || AccessSystem.new
      fields = %w(name service_owner application_manager)
      fields.each do |field|
        access_system.send("#{field}=", json_access_system[field])
      end
      access_system.save!
      if print_progress
        StringUtils.print_progress(start_time, index, json_access_systems.length,
                                   'Importing Access Systems from Medusa')
      end
    end
  end

  def import_resource_types(client, print_progress, start_time)
    raw_response = client.get(RESOURCE_TYPES_PATH)
    json_resource_types = JSON.parse(raw_response.body)
    json_resource_types.each.with_index do |json_resource_type, index|
      resource_type = ResourceType.find_by(name: json_resource_type['name']) || ResourceType.new
      fields = %w(name)
      fields.each do |field|
        resource_type.send("#{field}=", json_resource_type[field])
      end
      resource_type.save!
      if print_progress
        StringUtils.print_progress(start_time, index, json_access_systems.length,
                                   'Importing Access Systems from Medusa')
      end
    end
  end

end