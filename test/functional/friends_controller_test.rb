require File.dirname(__FILE__) + '/../test_helper'

class FriendsControllerTest < ActionController::TestCase
  
  context 'The FriendsController: ' do
  
    context 'A guest' do
      should_be_allowed('to view a user\'s following list') do
        get :following, :profile_id => somebody_other_than(nil)
      end
      should_be_unauthorized('to view a user\'s following list by tier') do
        get :following_by_tier, :profile_id => somebody_other_than(nil), :tier => 3
      end
      should_be_allowed('to view a user\'s followers list') do
        get :followers, :profile_id => somebody_other_than(nil)
      end
      should_be_allowed('to view a user\'s friends list') do
        get :friends, :profile_id => somebody_other_than(nil)
      end
      should_be_unauthorized('to add someone to a user\'s following list') do
        post :follow, :profile_id => somebody_other_than(nil), :follow_profile_id => :anything
      end
    end
  
    context 'A logged-in user' do
      setup do
        login_as :jack
      end

      should_be_forbidden('from viewing another user\'s following list by tier') do
        get :following_by_tier, :profile_id => somebody_other_than(current_user), :tier => 3
      end
      should_be_forbidden('from adding someone to another user\'s following list') do
        post :follow, :profile_id => somebody_other_than(current_user), :follow_profile_id => :anything
      end
      should_be_forbidden('from removing someone to another user\'s following list') do
        post :unfollow, :profile_id => somebody_other_than(current_user), :follow_profile_id => :anything
      end
      should_be_forbidden('from moving someone on another user\'s following list to a different tier') do
        post :move_to_tier, :profile_id => somebody_other_than(current_user), :follow_profile_id => :anything, :tier => 3
      end
      
      
      should_be_allowed('to view his own following list') do
        get :following, :profile_id => current_user
      end
      
      should_be_allowed('to view another user\'s following list') do
        get :following, :profile_id => somebody_other_than(current_user)
      end
      
      should_be_allowed('to view his own following list by tier') do
        get :following_by_tier, :profile_id => current_user, :tier => 1
      end
      
      should_be_allowed('to view his own followers list') do
        get :followers, :profile_id => current_user
      end
      
      should_be_allowed('to view another user\'s followers list') do
        get :followers, :profile_id => somebody_other_than(current_user)
      end
      
      should_be_allowed('to view his own friends list') do
        get :friends, :profile_id => current_user
      end
      
      should_be_allowed('to view another user\'s friends list') do
        get :friends, :profile_id => somebody_other_than(current_user)
      end
      
      should('be able to add someone to his following list') do
        post :follow, :profile_id => current_user, :follow_profile_id => :anything
        assert_redirected_to :action => 'following'
      end
      
      should('be able to remove someone to his following list') do
        post :unfollow, :profile_id => current_user, :follow_profile_id => :anything
        assert_redirected_to :action => 'following'
      end
      
      should('be able to move someone on his following list to a different tier') do
        post :move_to_tier, :profile_id => current_user, :follow_profile_id => :anything, :tier => 3
        assert_redirected_to :action => 'following_by_tier', :tier => 3
      end
    end
  
  end
  
end