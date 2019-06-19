require 'test_helper'

class VirtualRepositoriesControllerTest < ActionDispatch::IntegrationTest

  setup do
    log_in
    @virtual_repository = FactoryBot.create(:virtual_repository, title: 'Books')
    @repository = @virtual_repository.repository
  end

  test 'virtual repositories index' do
    get virtual_repositories_path
    assert_response :success
    assert_select 'table#virtual_repositories' do
      assert_select 'tr', 1 do
        assert_select 'td', 'Books'
        assert_select 'td', @repository.title
      end
    end
  end

  test 'virtual repositories show' do
    @collection = FactoryBot.create(:collection, repository: @repository, title: 'Math')
    @virtual_repository.collections << @collection
    get virtual_repository_path(@virtual_repository)
    assert_response :success
    assert_select 'a', 'Edit Virtual Repository'
    assert_select 'h2', 'Descriptive Metadata'
    assert_select 'dd', 'Books'
    assert_select 'ul#collections' do
      assert_select 'li a', 'Math'
    end
  end

  test 'virtual repositories destroy' do
    assert_difference 'VirtualRepository.count', -1 do
      delete virtual_repository_path(@virtual_repository)
    end
    assert_redirected_to repository_path(@repository)
  end

  test 'virtual repositories edit' do
    get edit_virtual_repository_path(@virtual_repository)
    assert_response :success
    assert_select 'a', 'Delete Virtual Repository'
    assert_select "form#edit_virtual_repository_#{@virtual_repository.id}"
  end

  test 'virtual repositories update' do
    assert_no_difference 'VirtualRepository.count' do
      patch virtual_repository_path(@virtual_repository, virtual_repository: {title: 'Videos'})
    end
    assert_redirected_to virtual_repository_path(@virtual_repository)
    assert VirtualRepository.find_by(title: 'Videos')
    refute VirtualRepository.find_by(title: 'Books')
  end

  test 'virtual repositories bad update' do
    patch virtual_repository_path(@virtual_repository, virtual_repository: {title: ''})
    refute VirtualRepository.find_by(title: '')
    assert VirtualRepository.find_by(title: 'Books')
    assert_select "form#edit_virtual_repository_#{@virtual_repository.id}"
  end

  test 'virtual repositories new' do
    get new_virtual_repository_path(repository_id: @repository.id)
    assert_response :success
    assert_select 'form#new_virtual_repository'
  end

  test 'virtual repositories create' do
    assert_difference 'VirtualRepository.count', 1 do
      post virtual_repositories_path(virtual_repository: {title: 'Videos', repository_id: @repository.id})
    end
    new_virtual_repository = VirtualRepository.find_by(title: 'Videos')
    assert new_virtual_repository
    assert_redirected_to virtual_repository_path(new_virtual_repository)
  end

  test 'virtual repositories bad create' do
    assert_no_difference 'VirtualRepository.count' do
      post virtual_repositories_path(virtual_repository: {title: '', repository_id: @repository.id})
    end
    assert_select 'form#new_virtual_repository'
  end


end