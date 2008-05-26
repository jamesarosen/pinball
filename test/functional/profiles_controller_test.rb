require File.dirname(__FILE__) + '/../test_helper'

class ProfilesControllerTest < ActionController::TestCase
  
  context 'A guest' do
    should 'be able to view a user\s profile' do
      get :show, :profile_id => :foo
      assert_response :success
    end
  end
  
  context 'A logged-in user' do
    setup do
      login_as :foo
    end
    
    should 'be able to view her dashboard' do
      get :dashboard, :profile_id => :foo
      assert_response :success
    end
    
    should 'be able to view her getting_started page' do
      get :getting_started, :profile_id => :foo
      assert_response :success
    end
    
    should 'be able to view her own profile' do
      get :show, :profile_id => :foo
      assert_response :success
    end
    
    should 'be able to view the form to edit her profile' do
      get :edit, :profile_id => :foo
      assert_response :success
    end
    
    should 'be able to edit her profile' do
      post :update, :profile_id => :foo
      assert_response :redirect
      assert_redirected_to :action => 'show'
    end
    
    should 'be able to view another user\s profile' do
      get :show, :profile_id => :bar
      assert_response :success
    end
    
    should 'be able to see the form to refer a friend' do
      get :refer_a_friend, :profile => :foo
      assert_response :success
    end
    
    should 'be able to refer a friend' do
      post :refer_a_friend, :profile => :foo
      assert_response :redirect
      assert_redirected_to :action => 'dashboard'
    end
  end
  
end
