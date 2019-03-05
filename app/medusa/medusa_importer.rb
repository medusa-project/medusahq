class MedusaImporter

  COLLECTIONS_PATH = '/collections.json'

  def import(print_progress = false)
    start_time = Time.now
    client = MedusaClient.instance

    # Import collections
    list_response = client.get(COLLECTIONS_PATH)
    list_struct   = JSON.parse(list_response.body)
    list_struct.each_with_index do |mc, index|
      show_path     = mc['path']
      show_response = client.get(show_path + '.json')
      show_struct   = JSON.parse(show_response.body)
      c = Collection.find_by(uuid: show_struct['uuid']) || Collection.new
      c.uuid                    = show_struct['uuid']
      c.title                   = show_struct['title']
      c.description             = show_struct['description']
      c.description_html        = show_struct['description_html']
      c.private_description     = show_struct['private_description'] # TODO: this doesn't exist
      c.access_url              = show_struct['access_url']
      c.physical_collection_url = show_struct['physical_collection_url']
      c.external_id             = show_struct['external_id']
      c.published               = show_struct['publish']
      c.representative_image_id = show_struct['representative_image']
      c.representative_item_id  = show_struct['representative_item']
      c.external_id             = show_struct['external_id']
      c.save!
      if print_progress
        StringUtils.print_progress(start_time, index, list_struct.length,
                                   'Importing from Medusa')
      end
    end
  end

end