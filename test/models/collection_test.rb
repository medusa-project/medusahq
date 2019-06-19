require 'test_helper'

class CollectionTest < ActiveSupport::TestCase

  setup do
    @subject = FactoryBot.create(:collection)
  end

  test 'new collections have an auto-generated repository ID' do
    expect(@subject.uuid).not_to be_empty
  end

  test 'collections must have a UUID-format repository ID' do
    wont allow_value('dogs', '', nil).for(:uuid)
  end

  test 'collections must have a title' do
    must validate_presence_of(:title)
  end

  test 'new collections have a medusa id if one is not already assigned' do
    expect(@subject.medusa_id).to be_instance_of(Integer)
  end

  test 'collections use uuid as identifying information' do
    expect(@subject.to_s).to eq(@subject.uuid)
    expect(@subject.to_param).to eq(@subject.uuid)
  end

  test 'collections know their peer collections' do
    @subject = FactoryBot.create(:collection)
    peer_1 = FactoryBot.create(:collection, repository: @subject.repository)
    peer_2 = FactoryBot.create(:collection, repository: @subject.repository)
    non_peer = FactoryBot.create(:collection)
    peers = @subject.peer_collections
    expect(peers).to include(peer_1)
    expect(peers).to include(peer_2)
    expect(peers).not_to include(@subject)
    expect(peers).not_to include(non_peer)
  end

  test 'blank contentdm_alias is nullified on save' do
    @subject.contentdm_alias = ''
    @subject.save!
    expect(@subject.contentdm_alias).to be_nil
  end

  test 'collection associations' do
    must belong_to(:repository).with_primary_key(:uuid).with_foreign_key(:repository_uuid)
    must have_many(:access_system_collection_joins).dependent(:destroy)
    must have_many(:access_systems).through(:access_system_collection_joins)
    must have_many(:collection_resource_type_joins).dependent(:destroy)
    must have_many(:resource_types).through(:collection_resource_type_joins)
    must have_many(:child_collection_joins).dependent(:destroy).with_foreign_key(:parent_collection_id).class_name('SubcollectionJoin')
    must have_many(:child_collections).through(:child_collection_joins)
    must have_many(:parent_collection_joins).dependent(:destroy).with_foreign_key(:child_collection_id).class_name('SubcollectionJoin')
    must have_many(:parent_collections).through(:parent_collection_joins)
  end

  test 'collection delegates some methods to repository' do
    must delegate_method(:title).to(:repository).with_prefix(true)
  end

  test 'validate package profile' do
    must validate_inclusion_of(:package_profile).in_array(Settings.package_profiles).allow_blank(true)
  end

end
