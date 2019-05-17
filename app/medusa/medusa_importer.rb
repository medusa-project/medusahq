class MedusaImporter

  COLLECTIONS_PATH = '/collections.json'
  REPOSITORIES_PATH = '/repositories.json'
  ACCESS_SYSTEMS_PATH = '/access_systems.json'
  RESOURCE_TYPES_PATH = '/resource_types.json'

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

  def import_collections(client, print_progress, start_time)
    list_response = client.get(COLLECTIONS_PATH)
    list_struct = JSON.parse(list_response.body)
    #this will map parent to child collections by their medusa_ids. At the end we'll use that to set up the
    # right parent/child collections here by their HQ ids
    parent_child_collections = Hash.new
    list_struct.each_with_index do |mc, index|
      show_path = mc['path']
      show_response = client.get(show_path + '.json')
      show_struct = JSON.parse(show_response.body)
      c = Collection.find_by(uuid: show_struct['uuid']) || Collection.new
      %w(uuid title description description_html private_description access_url physical_collection_url
          external_id repository_uuid contact_email).each do |field|
        c.send("#{field}=", show_struct[field])
      end
      {publish: :published, representative_image: :representative_image_id, representative_item: :representative_item_id,
       id: :medusa_id}.each do |cr_field, hq_field|
        c.send("#{hq_field}=", show_struct[cr_field.to_s])
      end
      c.save!
      show_struct['access_systems'].each do |json_access_system|
        name = json_access_system['name']
        access_system = AccessSystem.find_by(name: name) || raise("Access System not found #{name}")
        c.access_systems << access_system
      end
      show_struct['resource_types'].each do |json_resource_type|
        name = json_resource_type['name']
        resource_type = ResourceType.find_by(name: name) || raise("Resource Type not found #{name}")
        c.resource_types << resource_type
      end
      json_child_collections = show_struct['child_collections']
      if json_child_collections.present?
        parent_child_collections[c.medusa_id] = json_child_collections.collect(&:id)
      end
      if print_progress
        StringUtils.print_progress(start_time, index, list_struct.length,
                                   'Importing Collections from Medusa')
      end
    end
    parent_child_collections.each do |parent_medusa_id, child_medusa_ids|
      parent_collection = Collection.find_by(medusa_id: parent_medusa_id)
      child_medusa_ids.each do |child_medusa_id|
        child_collection = Collection.find_by(medusa_id: child_medusa_id)
        parent_collection.child_collections << child_collection
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