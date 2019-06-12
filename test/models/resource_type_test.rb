require 'test_helper'

class ResourceTypeTest < ActiveSupport::TestCase

  test 'resource type associations and validations' do
    @subject = ResourceType.new
    must have_many(:collection_resource_type_joins).dependent(:destroy)
    must have_many(:collections).through(:collection_resource_type_joins)
    must validate_presence_of(:name)
  end

end