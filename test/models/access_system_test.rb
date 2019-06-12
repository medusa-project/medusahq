require 'test_helper'

class AccessSystemTest < ActiveSupport::TestCase

  setup do
    @access_system = FactoryBot.create(:access_system)
  end

  test 'access system validations' do
    must validate_presence_of(:name)
  end

  test 'access system associations' do
    must have_many(:access_system_collection_joins).dependent(:destroy)
    must have_many(:collections).through(:access_system_collection_joins)
  end

end