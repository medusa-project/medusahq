require 'test_helper'

class RepositoriesControllerTest < ActionDispatch::IntegrationTest

  setup do
    log_in
    @repository = FactoryBot.create(:repository, title: 'Archives')
  end

  test 'repositories index' do
    get repositories_path
    assert_response :success
    assert_select 'table#repositories' do
      assert 'td', 'Archives'
    end
    assert_select 'a', 'New Repository'
    assert_select 'a', 'Edit Ldap Admins'
  end

  test 'repository show' do
    #just do a sample of attributes
    @repository = FactoryBot.create(:repository, title: 'Grainger', url: 'http://grainger.example.com', zip: '61801',
                                    email: 'someone@example.com')
    @collection = FactoryBot.create(:collection, title: 'Stuff', external_id: '1234', repository: @repository)
    get repository_path(@repository)
    assert_response :success
    assert_select 'h1', 'Grainger'
    assert_select 'dd', 'http://grainger.example.com'
    assert_select 'dd', '61801'
    assert_select 'dd', 'someone@example.com'
    assert_select 'table#collections' do
      assert_select 'td', 'Stuff'
      assert_select 'td', '1234'
    end
    assert_select 'a', 'Edit Repository'
    assert_select 'a', 'New Virtual Repository'
    assert_select 'a', 'New Collection'
  end

  test 'repository destroy' do
    assert_difference 'Repository.count', -1 do
      delete repository_path(@repository)
    end
    assert_redirected_to repositories_path
  end

  test 'repository edit' do
    get edit_repository_path(@repository)
    assert_response :success
    assert_select 'a', 'Delete Repository'
    assert_select "form#edit_repository_#{@repository.id}"
  end

  test 'repository update' do
    patch repository_path(@repository, repository: {title: 'Grainger', city: 'Urbana'})
    assert_redirected_to repository_path(@repository)
    assert Repository.find_by(title: 'Grainger', city: 'Urbana')
    refute Repository.find_by(title: 'Archives')
  end

  test 'repository bad update' do
    patch repository_path(@repository, repository: {title: '', city: 'Urbana'})
    assert Repository.find_by(title: 'Archives')
    refute Repository.find_by(title: '')
    assert_select "form#edit_repository_#{@repository.id}"
  end

  test 'repository new' do
    get new_repository_path
    assert_response :success
    assert_select 'form#new_repository'
  end

  test 'repository create' do
    assert_difference 'Repository.count', 1 do
      post repositories_path(repository: {title: 'Grainger'})
    end
    new_repository = Repository.find_by(title: 'Grainger')
    assert new_repository
    assert_redirected_to repository_path(new_repository)
  end

  test 'repository bad create' do
    assert_no_difference 'Repository.count' do
      post repositories_path(repository: {title: ''})
    end
    assert_select 'form#new_repository'
  end

  test 'edit ldap admins' do
    get edit_ldap_admins_repositories_path
    assert_response :success
    assert_select "form#edit_repository_#{@repository.id}" do
      assert_select 'a', 'Archives'
      assert_select 'input[value="Update"]'
    end
  end

  test 'update ldap admin for a repository' do
    put update_ldap_admin_repository_path(@repository, repository: {ldap_admin_group: 'LDAP Group'})
    assert_redirected_to edit_ldap_admins_repositories_path
    assert_equal 'LDAP Group', @repository.reload.ldap_admin_group
  end

  test 'update ldap admin for a repository, xhr' do
    put update_ldap_admin_repository_path(@repository, repository: {ldap_admin_group: 'LDAP Group'}), xhr: true
    assert_equal 'LDAP Group', @repository.reload.ldap_admin_group
  end

end