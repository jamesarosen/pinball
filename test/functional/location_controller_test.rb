require File.dirname(__FILE__) + '/../test_helper'

class LocationControllerTest < ActionController::TestCase

  context 'A guest' do
    should_be_allowed 'to view a user\'s location' do
      get :current, :profile_id => anybody
    end
    
    should_be_unauthorized 'to edit a user\'s location' do
      get :edit, :profile_id => anybody
    end
    
    should_be_unauthorized 'to see who is near a user' do
      get :whos_around, :profile_id => anybody
    end
  end
  
  context 'A logged-in user' do
    setup do
      login_as :joan
    end
    
    should_be_allowed 'to view her own location' do
      get :current, :profile_id => current_user
      assert_equal locations(:new_york_ny), assigns(:location)
    end
    
    should_be_allowed 'to view another user\'s location' do
      get :current, :profile_id => somebody_other_than(current_user)
      assert_not_nil assigns(:location)
    end
    
    should_be_allowed 'to see the form to change her location' do
      get :edit, :profile_id => current_user
    end
    
    should 'be able to set her location to Nowhere' do
      post :update, :profile_id => current_user
      assert_response :redirect
      assert_redirected_to :controller => 'profiles', :action => 'dashboard'
    end
    
    should 'be able to change her location' do
      @houston = locations(:houston_tx)
      Location.expects(:parse).with('anywhere').returns(@houston)
      
      post :update, :profile_id => current_user, :location => 'anywhere'
      assert_response :redirect
      assert_redirected_to :action => 'whos_around'
      assert_equal @houston, current_user.profile.location
    end
    
    should 'not be able to change her location to an unparseable string' do
      old_location = current_user.profile.location
      Location.expects(:parse).with('anywhere').raises(Location::ParseError.new('foo'))
      post :update, :profile_id => current_user, :location => 'anywhere'
      assert_template 'location/edit'
      assert_equal old_location, current_user.profile.location
    end
    
    should_be_forbidden 'from changing another user\'s location' do
      post :update, :profile_id => somebody_other_than(current_user)
    end
    
    should 'be able to see who\'s around' do
      get :whos_around, :profile_id => current_user
      assert_not_nil assigns(:whos_around)
      assert assigns(:whos_around).kind_of?(Array)
    end
    
    should 'be forbidden from seeing who\'s around another user' do
      get :whos_around, :profile_id => somebody_other_than(current_user)
    end
  end

end
