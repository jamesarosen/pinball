require File.dirname(__FILE__) + '/../test_helper'

class FavoriteLocationsControllerTest < ActionController::TestCase
  
  context 'The FavoriteLocationsController:' do
    context 'A guest' do
      should_be_unauthorized 'to view a user\'s favorite locations' do
        get :index, :profile_id => anybody
      end
      should_be_unauthorized 'to add a favorite location to a user\'s list' do
        post :create, :profile_id => anybody
      end
      should_be_unauthorized 'to update a user\'s favorite location' do
        put :update, :profile_id => anybody, :favorite_location_id => 'anything'
      end
      should_be_unauthorized 'to delete a user\'s favorite location' do
        delete :destroy, :profile_id => anybody, :favorite_location_id => 'anything'
      end
    end
    
    context 'a logged-in user' do
      setup do
        login_as :joan
        assert logged_in?
        assert_not_nil current_user
      end
      
      should_be_forbidden 'from viewing another user\'s favorite locations' do
        get :index, :profile_id => somebody_other_than(current_user)
      end
      should_be_forbidden' from adding a favorite location to another user\'s list' do
        post :create, :profile_id => somebody_other_than(current_user)
      end
      should_be_forbidden 'from updating another user\'s favorite location' do
        put :update, :profile_id => somebody_other_than(current_user), :favorite_location_id => 'anything'
      end
      should_be_forbidden 'from deleting another user\'s favorite location' do
        delete :destroy, :profile_id => somebody_other_than(current_user), :favorite_location_id => 'anything'
      end
      
      
      should_be_allowed 'to see her own favorite locations' do
        get :index, :profile_id => current_profile
      end
      
      should_be_allowed 'to view the form to add a new favorite location' do
        get :new, :profile_id => current_profile
      end
      
      should 'be able to create a new favorite location' do
        somewhere = Location::Base.find(:first)
        assert_difference('current_profile.favorite_locations.size', 1) do
          post :create, :profile_id => current_profile, :favorite_location => { :location => somewhere.address, :name => 'anything' }
          assert_redirected_to :action => 'index'
        end
      end
      
      should 'not be able to create a new favorite location for somebody else by hacking the parameters' do
        other = somebody_other_than(current_user)
        somewhere = Location::Base.find(:first)
        assert_difference('other.profile.favorite_locations.size', 0) do
          post :create, :profile_id => current_profile, :favorite_location => { :location => somewhere, :profile => other, :name => 'anything' }
        end
      end
      
      should_be_allowed 'to view the form to edit an existing favorite location' do
        get :edit, :profile_id => current_profile, :favorite_location_id => current_profile.favorite_locations.first
      end
      
      should 'be able to update an existing favorite location' do
        fave = current_profile.favorite_locations.first
        assert_not_equal 'foo', fave.name
        put :update, :profile_id => current_profile, :favorite_location_id => fave, :favorite_location => { :name => 'foo' }
        assert_redirected_to :action => 'index'
        assert_equal 'foo', fave.reload.name
      end

      should 'be able to delete an existing favorite location' do
        assert_difference('current_profile.favorite_locations.size', -1) do
          delete :destroy, :profile_id => current_profile, :favorite_location_id => current_profile.favorite_locations.first
          assert_redirected_to :action => 'index'
        end
      end
      
    end
    
  end
end

  
