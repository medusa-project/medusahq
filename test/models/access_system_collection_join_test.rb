require 'test_helper'

class AccessSystemCollectionJoinTest < ActiveSupport::TestCase
  test 'access system collection joins associations and validations' do
    @subject = AccessSystemCollectionJoin.new
    must belong_to(:collection)
    must belong_to(:access_system)
    must validate_presence_of(:collection_id)
    must validate_presence_of(:access_system_id)
    must validate_uniqueness_of(:access_system_id).scoped_to(:collection_id)
  end
end