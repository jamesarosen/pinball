require File.dirname(__FILE__) + '/../test_helper'

class FavoriteLocationsControllerTest < ActionController::TestCase
  
  context 'A logged-in user' do
    setup do
      login_as :foo
    end
    should 'be able to view a list of saved favorite locations' do
      get :list, :profile_id => :foo
      assert_response :success
    end
    should 'be able to see the form to add a new favorite location' do
      get :add, :profile_id => :foo
      assert_response :success
    end
    should 'be able to create new favorite location' do
      post :create, :profile_id => :foo
      assert_response :redirect
      assert_redirected_to :action => 'list'
    end
    should 'be able to see the form to edit an existing favorite location' do
      get :edit, :profile_id => :foo, :favorite_location_id => 1324
      assert_response :success
    end
    should 'be able to update an existing favorite location' do
      post :update, :profile_id => :foo, :favorite_location_id => 1324
      assert_response :redirect
      assert_redirected_to :action => 'list'
    end
    should 'be able to delete an existing favorite location' do
      post :delete, :profile_id => :foo, :favorite_location_id => 1324
      assert_response :redirect
      assert_redirected_to :action => 'list'
    end
  end
  
end
