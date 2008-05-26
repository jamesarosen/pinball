require File.dirname(__FILE__) + '/../test_helper'

class FriendsControllerTest < ActionController::TestCase
  
  context 'A guest' do
    should 'be able to view a user\'s following list' do
      get :following, :profile_id => :foo
      assert_response :success
    end
    
    should 'be able to view a user\'s followers list' do
      get :followers, :profile_id => :foo
      assert_response :success
    end
    
    should 'be able to view a user\'s friends list' do
      get :friends, :profile_id => :foo
      assert_response :success
    end
  end
  
  context 'A logged-in user' do
    setup do
      login_as :foo
    end
    
    should 'be able to view her own following list' do
      get :following, :profile_id => :foo
      assert_response :success
    end
    
    should 'be able to view her own following list for a particular tier' do
      get :following_by_tier, :profile_id => :foo, :tier => 2
      assert_response :success
    end
    
    should 'be able to view her own followers list' do
      get :followers, :profile_id => :foo
      assert_response :success
    end
    
    should 'be able to view her own friends list' do
      get :friends, :profile_id => :foo
      assert_response :success
    end
    
    should 'be able to follow another user' do
      post :follow, :profile_id => :foo, :follow_profile_id => :bar
      assert_response :redirect
      assert_redirected_to :action => 'following'
    end
    
    should 'be able to unfollow another user' do
      post :unfollow, :profile_id => :foo, :follow_profile_id => :bar
      assert_response :redirect
      assert_redirected_to :action => 'following'
    end
    
    should 'be able to view another user\'s following list' do
      get :following, :profile_id => :bar
      assert_response :success
    end
    
    should 'be able to view another user\'s followers list' do
      get :followers, :profile_id => :bar
      assert_response :success
    end
    
    should 'be able to view another user\'s friends list' do
      get :friends, :profile_id => :bar
      assert_response :success
    end
  end
  
end
