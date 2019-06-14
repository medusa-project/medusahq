require 'test_helper'

class AccessSystemsControllerTest < ActionDispatch::IntegrationTest

  setup do
    log_in
    @access_system = FactoryBot.create(:access_system, name: 'IDEALS', service_owner: 'owner@example.com', application_manager: 'manager@example.com')
  end

  test 'access systems index' do
    get access_systems_path
    assert_response :success
    assert_select 'table#access-systems' do
      assert_select 'tr', 1
      assert_select 'td', 'IDEALS'
      assert_select 'td', 'owner@example.com'
      assert_select 'td', 'manager@example.com'
    end
  end

  test 'access system show' do
    get access_system_path(@access_system)
    assert_response :success
    assert_select 'a', 'Edit Access System'
    assert_select 'dd', 'IDEALS'
    assert_select 'dd', 'owner@example.com'
    assert_select 'dd', 'manager@example.com'
  end

  test 'access system show collections' do
    @collection = FactoryBot.create(:collection, title: 'My Collection', external_id: '2142/5678')
    @collection.access_systems << @access_system
    get collections_access_system_path(@access_system)
    assert_response :success
    assert_select 'table#collections' do
      assert_select 'td', '2142/5678'
      assert_select 'td', 'My Collection'
    end
  end

  test 'access system destroy' do
    assert_difference 'AccessSystem.count', -1 do
      delete access_system_path(@access_system)
    end
    assert_redirected_to access_systems_path
  end

  test 'access system edit' do
    get edit_access_system_path(@access_system)
    assert_response :success
    assert_select 'a', 'Delete Access System'
    assert_select "form#edit_access_system_#{@access_system.id}"
  end

  test 'access system update' do
    patch access_system_path(@access_system, access_system: {name: 'New Name', service_owner: 'newowner@example.com'})
    assert_redirected_to access_system_path(@access_system)
    assert AccessSystem.find_by(name: 'New Name', service_owner: 'newowner@example.com')
    refute AccessSystem.find_by(name: 'IDEALS', service_owner: 'owner@example.com')
  end

  test 'access system bad update' do
    patch access_system_path(@access_system, access_system: {name: ''})
    refute AccessSystem.find_by(name: '')
    assert AccessSystem.find_by(name: 'IDEALS')
    assert_select "form#edit_access_system_#{@access_system.id}"
  end

  test 'access system new' do
    get new_access_system_path
    assert_response :success
    assert_select 'form#new_access_system'
  end

  test 'access system create' do
    assert_difference 'AccessSystem.count', 1 do
      post access_systems_path(access_system: {name: 'New Name', service_owner: 'newowner@example.com'})
    end
    new_access_system = AccessSystem.find_by(name: 'New Name', service_owner: 'newowner@example.com')
    assert new_access_system
    assert_redirected_to access_system_path(new_access_system)
  end

  test 'access system bad create' do
    assert_difference 'AccessSystem.count', 0 do
      post access_systems_path(access_system: {name: '', service_owner: 'newowner@example.com'})
    end
    assert_select 'form#new_access_system'
  end

end