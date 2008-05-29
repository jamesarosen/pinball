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
    end
    
    should_be_allowed 'to view another user\'s location' do
      get :current, :profile_id => somebody_other_than(current_user)
    end
    
    should_be_allowed 'to see the form to change her location' do
      get :edit, :profile_id => current_user
    end
    
    should 'be able to change her location' do
      post :update, :profile_id => current_user
      assert_response :redirect
      assert_redirected_to :action => 'whos_around'
    end
    
    should_be_forbidden 'from changing another user\'s location' do
      post :update, :profile_id => somebody_other_than(current_user)
    end
    
    should 'be able to see who\'s around' do
      get :whos_around, :profile_id => current_user
    end
    
    should 'be forbidden from seeing who\'s around another user' do
      get :whos_around, :profile_id => somebody_other_than(current_user)
    end
  end

end
