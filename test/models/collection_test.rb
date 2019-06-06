require 'test_helper'

class CollectionTest < ActiveSupport::TestCase

  test 'new collections have an auto-generated repository ID' do
    c = FactoryBot.create(:collection)
    assert_not_empty c.uuid
  end

  test 'collections must have a UUID-format repository ID' do
    c = FactoryBot.create(:collection)
    assert_raises ActiveRecord::RecordInvalid do
      c.update!(uuid: 'dogs')
    end
  end

  test 'collections must have a title' do
    c = FactoryBot.create(:collection)

    c.title = nil
    assert_raises ActiveRecord::RecordInvalid do
      c.save!
    end

    c.title = ''
    assert_raises ActiveRecord::RecordInvalid do
      c.save!
    end
  end

  test 'new collections have a medusa id if one is not already assigned' do
    c = FactoryBot.create(:collection)
    assert_kind_of Integer, c.medusa_id
  end

  test 'collections use uuid as identifying information' do
    c = FactoryBot.create(:collection)
    assert_equal c.uuid, c.to_s
    assert_equal c.uuid, c.to_param
  end

  test 'collections know their peer collections' do
    c = FactoryBot.create(:collection)
    peer_1 = FactoryBot.create(:collection, repository: c.repository)
    peer_2 = FactoryBot.create(:collection, repository: c.repository)
    non_peer = FactoryBot.create(:collection)
    peers = c.peer_collections
    assert_includes peers, peer_1
    assert_includes peers, peer_2
    assert_not_includes peers, c
    assert_not_includes peers, non_peer
  end

end
