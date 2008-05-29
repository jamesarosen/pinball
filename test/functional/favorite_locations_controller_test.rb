require File.dirname(__FILE__) + '/../test_helper'

class FavoriteLocationsControllerTest < ActionController::TestCase
  
  context 'The FavoriteLocationsController:' do
    
    context 'A guest' do
      should_be_unauthorized 'to view a user\'s favorite locations' do
        get :list, :profile_id => anybody
      end
      should_be_unauthorized 'to add a favorite location to a user\'s list' do
        post :create, :profile_id => anybody
      end
      should_be_unauthorized 'to update a user\'s favorite location' do
        post :update, :profile_id => anybody, :favorite_location_id => :anything
      end
      should_be_unauthorized 'to delete a user\'s favorite location' do
        post :delete, :profile_id => anybody, :favorite_location_id => :anything
      end
    end
    
    context 'a logged-in user' do
      setup do
        login_as :joan
        assert logged_in?
        assert_not_nil current_user
      end
      
      should_be_forbidden 'from viewing another user\'s favorite locations' do
        get :list, :profile_id => somebody_other_than(current_user)
      end
      should_be_forbidden' from adding a favorite location to another user\'s list' do
        post :create, :profile_id => somebody_other_than(current_user)
      end
      should_be_forbidden 'from updating another user\'s favorite location' do
        post :update, :profile_id => somebody_other_than(current_user), :favorite_location_id => :anything
      end
      should_be_forbidden 'from deleting another user\'s favorite location' do
        post :delete, :profile_id => somebody_other_than(current_user), :favorite_location_id => :anything
      end
      
      
      should_be_allowed 'to see her own favorite locations' do
        get :list, :profile_id => current_user
      end
      
      should_be_allowed 'to view the form to add a new favorite location' do
        get :add, :profile_id => current_user
      end
      
      should 'be able to create a new favorite location' do
        post :create, :profile_id => current_user
        assert_redirected_to :action => 'list'
      end
      
      should_be_allowed 'to view the form to edit an existing favorite location' do
        get :edit, :profile_id => current_user, :favorite_location_id => 1234
      end
      
      should 'be able to update an existing favorite location' do
        post :update, :profile_id => current_user, :favorite_location_id => 1324
        assert_redirected_to :action => 'list'
      end

      should 'be able to delete an existing favorite location' do
        post :delete, :profile_id => current_user, :favorite_location_id => 1324
        assert_redirected_to :action => 'list'
      end
      
    end
    
  end
  
end

  
