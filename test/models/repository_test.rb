require 'test_helper'

class RepositoryTest < ActiveSupport::TestCase

  setup do
    @repository = FactoryBot.create(:repository)
  end

  test 'new repositories have an auto-generated repository ID' do
    expect(@repository.uuid).not_to be_empty
  end

  test 'repository must have a UUID-format repository ID' do
    wont allow_value('dogs').for(:uuid)
  end

  test 'repositories must have a title' do
    must validate_presence_of(:title)
  end

  test 'repositories use uuid as identifying information' do
    expect(@repository.to_param).to eq(@repository.uuid)
  end

  test 'repositories have associations' do
    must have_many(:collections).with_primary_key(:uuid).with_foreign_key(:repository_uuid)
    must have_many(:virtual_repositories).dependent(:destroy)
  end
end
