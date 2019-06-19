require 'test_helper'

class CollectionsControllerTest < ActionDispatch::IntegrationTest

  setup do
    log_in
    @collection = FactoryBot.create(:collection, title: 'Animals', external_id: '5432')
  end

  test 'collections index' do
    get collections_path
    assert_response :success
    assert_select 'table#collections' do
      assert_select 'tr', 1 do
        assert_select 'td', 'Animals'
        assert_select 'td', '5432'
      end
    end
  end

  test 'collection show' do
    get collection_path(@collection)
    assert_response :success
    assert_select 'a', 'Edit Collection'
    assert_select 'h1', @collection.title
    assert_select 'h2', 'Descriptive Metadata'
    assert_select 'h2', 'Administrative Metadata'
  end

  test 'collection destroy' do
    assert_difference 'Collection.count', -1 do
      delete collection_path(@collection)
    end
    assert_redirected_to collections_path
  end

  test 'collection edit' do
    get edit_collection_path(@collection)
    assert_response :success
    assert_select 'a', 'Delete Collection'
    assert_select "form#edit_collection_#{@collection.id}"
  end

  test 'collection update' do
    assert_no_difference 'Collection.count' do
      patch collection_path(@collection, collection: {title: 'New Title', external_id: 'New Id'})
    end
    assert_redirected_to collection_path(@collection)
    assert Collection.find_by(title: 'New Title', external_id: 'New Id')
    refute Collection.find_by(title: 'Animals', external_id: '5432')
  end

  test 'collection bad update' do
    patch collection_path(@collection, collection: {title: ''})
    refute Collection.find_by(title: '')
    assert Collection.find_by(title: 'Animals')
    assert_select "form#edit_collection_#{@collection.id}"
  end

  test 'collection new' do
    get new_collection_path
    assert_response :success
    assert_select 'form#new_collection'
  end

  test 'collection create' do
    assert_difference 'Collection.count', 1 do
      post collections_path(collection: {title: 'Plants', repository_uuid: @collection.repository_uuid})
    end
    new_collection = Collection.find_by(title: 'Plants')
    assert new_collection
    assert_redirected_to collection_path(new_collection)
  end

  test 'collection bad create' do
    assert_difference 'Collection.count', 0 do
      post collections_path(collection: {title: '', repository_uuid: @collection.repository_uuid})
    end
    assert_select 'form#new_collection'
  end

end
