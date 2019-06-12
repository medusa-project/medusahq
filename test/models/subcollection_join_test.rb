require 'test_helper'

class SubcollectionJoinTest < ActiveSupport::TestCase

  setup do
    @parent = FactoryBot.create(:collection)
    @child = FactoryBot.create(:collection, repository: @parent.repository)
    @subject = SubcollectionJoin.create(parent_collection_id: @parent.id, child_collection_id: @child.id)
  end

  test 'subcollection join associations and validations' do
    must belong_to(:parent_collection).class_name('Collection')
    must belong_to(:child_collection).class_name('Collection')
    must validate_presence_of(:parent_collection_id)
    must validate_presence_of(:child_collection_id)
    must validate_uniqueness_of(:child_collection_id).scoped_to(:parent_collection_id)
  end

end