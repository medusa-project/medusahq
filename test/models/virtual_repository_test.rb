require 'test_helper'

class VirtualRepositoryTest < ActiveSupport::TestCase

  test 'virtual repository associations and validations' do
    @subject = VirtualRepository.new
    must belong_to(:repository)
    must have_many(:collection_virtual_repository_joins).dependent(:destroy)
    must have_many(:collections).through(:collection_virtual_repository_joins)
    must validate_presence_of(:title)
  end

end