require File.dirname(__FILE__) + '/../test_helper'

class LocationControllerTest < ActionController::TestCase

  context 'A guest' do
    should 'be able to view a user\'s location' do
      get :current, :profile_id => :foo
      assert_response :success
    end
  end
  
  context 'A logged-in user' do
    setup do
      login_as :foo
    end
    
    should 'be able to view her own location' do
      get :current, :profile_id => :foo
      assert_response :success
    end
    
    should 'be able to see the form to change her location' do
      get :edit, :profile_id => :foo
      assert_response :success
    end
    
    should 'be able to change her location' do
      post :update, :profile_id => :foo
      assert_response :redirect
      assert_redirected_to :action => 'whos_around'
    end
    
    should 'be able to see who\'s around' do
      get :whos_around
      assert_response :success
    end
    
    should 'be able to view another user\'s location' do
      get :current, :profile_id => :bar
      assert_response :success
    end
  end

end
