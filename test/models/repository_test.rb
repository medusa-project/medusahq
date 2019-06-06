require 'test_helper'

class RepositoryTest < ActiveSupport::TestCase

  test 'new repositories have an auto-generated repository ID' do
    repository = FactoryBot.create(:repository)
    assert_not_empty repository.uuid
  end

  test 'repository must have a UUID-format repository ID' do
    repository = FactoryBot.create(:repository)
    assert_raises ActiveRecord::RecordInvalid do
      repository.update!(uuid: 'dogs')
    end
  end

  test 'repositories must have a title' do
    repository = FactoryBot.create(:repository)

    [nil, ''].each do |title|
      repository.title = title
      assert_raises ActiveRecord::RecordInvalid do
        repository.save!
      end
    end
  end

  test 'repositories use uuid as identifying information' do
    repository = FactoryBot.create(:repository)
    assert_equal repository.uuid, repository.to_param
  end

end
