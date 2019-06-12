require 'test_helper'

class CollectionVirtualRepositoryJoinTest < ActiveSupport::TestCase

  test 'collection virtual repository join associations and validations' do
    virtual_repository = FactoryBot.create(:virtual_repository)
    collection = FactoryBot.create(:collection, repository: virtual_repository.repository)
    virtual_repository.collections << collection
    @subject = virtual_repository.collection_virtual_repository_joins.first
    must belong_to(:collection)
    must belong_to(:virtual_repository)
    must validate_presence_of(:collection_id)
    must validate_presence_of(:virtual_repository_id)
    must validate_uniqueness_of(:collection_id).scoped_to(:virtual_repository_id)
  end

end