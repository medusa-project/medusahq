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

end
