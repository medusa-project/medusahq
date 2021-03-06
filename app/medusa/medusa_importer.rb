class MedusaImporter

  attr_accessor :start_time, :client, :print_progress

  COLLECTIONS_PATH = '/collections.json'
  REPOSITORIES_PATH = '/repositories.json'
  ACCESS_SYSTEMS_PATH = '/access_systems.json'
  RESOURCE_TYPES_PATH = '/resource_types.json'
  VIRTUAL_REPOSITORIES_PATH = '/virtual_repositories.json'

  def import(print_progress = false)
    self.start_time = Time.now
    self.client = MedusaClient.instance
    self.print_progress = print_progress

    import_access_systems
    import_resource_types
    import_repositories
    import_collections
    import_virtual_repositories
  end

  private

  def import_collections
    list_response = client.get(COLLECTIONS_PATH)
    list_struct = JSON.parse(list_response.body)
    #this will map parent to child collections by their medusa_ids. At the end we'll use that to set up the
    # right parent/child collections here by their HQ ids
    parent_child_collections = Hash.new
    list_struct.each_with_index do |mc, index|
      show_path = mc['path']
      show_response = client.get(show_path + '.json')
      show_struct = JSON.parse(show_response.body)
      c = import_single_object(Collection, show_struct, 'uuid',
                               %w(uuid title description description_html private_description access_url
                                  physical_collection_url external_id repository_uuid contact_email),
                               {publish: :published, representative_image: :representative_image_id,
                                representative_item: :representative_item_id, id: :medusa_id})
      show_struct['access_systems'].each do |json_access_system|
        name = json_access_system['name']
        access_system = AccessSystem.find_by(name: name) || raise("Access System not found #{name}")
        c.access_systems << access_system unless c.access_systems.include?(access_system)
      end
      show_struct['resource_types'].each do |json_resource_type|
        name = json_resource_type['name']
        resource_type = ResourceType.find_by(name: name) || raise("Resource Type not found #{name}")
        c.resource_types << resource_type unless c.resource_types.include?(resource_type)
      end
      json_child_collections = show_struct['child_collections']
      if json_child_collections.present?
        parent_child_collections[c.medusa_id] = json_child_collections.collect {|collection| collection['id'] }
      end
      maybe_print_progress(index, list_struct, Collection)
    end
    parent_child_collections.each do |parent_medusa_id, child_medusa_ids|
      parent_collection = Collection.find_by(medusa_id: parent_medusa_id)
      child_medusa_ids.each do |child_medusa_id|
        child_collection = Collection.find_by(medusa_id: child_medusa_id)
        parent_collection.child_collections << child_collection unless parent_collection.child_collections.include?(child_collection)
      end
    end
  end

  def import_access_systems
    import_generic(ACCESS_SYSTEMS_PATH, AccessSystem, 'name', %w(name service_owner application_manager))
  end

  def import_resource_types
    import_generic(RESOURCE_TYPES_PATH, ResourceType, 'name', %w(name))
  end

  #a little bit easier than collections, since the index exports all the relevant information
  def import_repositories
    import_generic(REPOSITORIES_PATH, Repository, 'uuid',
                   %w(uuid title url notes address_1 address_2 city state zip phone_number email contact_email ldap_admin_group))
  end

  def import_virtual_repositories
    raw_response = client.get(VIRTUAL_REPOSITORIES_PATH)
    json_objects = JSON.parse(raw_response.body)
    json_objects.each do |json_object|
      repository = Repository.find_by(uuid: json_object['repository_uuid'])
      virtual_repository = VirtualRepository.find_or_create_by!(repository: repository, title: json_object['title'])
      json_object['collections'].each do |collection|
        collection = Collection.find_by(uuid: collection['uuid'])
        virtual_repository.collections << collection unless virtual_repository.collections.include?(collection)
      end
    end
  end

  #Many of these give all the info we need from an index call as an array of object, in which case we can do this more generically
  def import_generic(cr_url, klass, key_field, *field_specs)
    raw_response = client.get(cr_url)
    json_objects = JSON.parse(raw_response.body)
    json_objects.each.with_index do |json_object, index|
      import_single_object(klass, json_object, key_field, *field_specs)
      maybe_print_progress(index, json_objects, klass)
    end
  end

  def maybe_print_progress(index, json_objects, klass)
    if print_progress
      StringUtils.print_progress(start_time, index, json_objects.length,
                                 "Importing #{klass.to_s.pluralize.underscore.humanize} from Medusa")
    end
  end

  def import_single_object(klass, json_object, key_field, *field_specs)
    (klass.find_by(key_field => json_object[key_field.to_s]) || klass.new).tap do |object|
      set_fields(object, json_object, *field_specs)
      object.save!
    end
  end

  # Each field spec is either a map from the fields in the json to the field names in HQ
  # or a simple array of field names if they are the same
  def set_fields(object, json_object, *field_specs)
    field_specs.each do |field_spec|
      field_spec = field_spec.zip(field_spec).to_h if field_spec.is_a?(Array)
      field_spec.each do |json_field, hq_field|
        object.send("#{hq_field}=", json_object[json_field.to_s])
      end
    end
  end

end