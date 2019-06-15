require 'test_helper'

class CollectionResourceTypeJoinTest < ActiveSupport::TestCase

  test 'collection resource type join associations and validations' do
    @collection = FactoryBot.create(:collection)
    @resource_type = FactoryBot.create(:resource_type)
    @collection.resource_types << @resource_type
    @subject = CollectionResourceTypeJoin.first
    must belong_to(:collection)
    must belong_to(:resource_type)
    must validate_presence_of(:collection_id)
    must validate_presence_of(:resource_type_id)
    must validate_uniqueness_of(:resource_type_id).scoped_to(:collection_id)
  end

end