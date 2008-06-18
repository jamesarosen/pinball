require File.dirname(__FILE__) + '/../test_helper'

class FriendsControllerTest < ActionController::TestCase
  
  context 'The FriendsController: ' do
  
    context 'A guest' do
      should_be_allowed('to view a user\'s following list') do
        get :following, :profile_id => anybody
      end
      should_be_unauthorized('to view a user\'s following list by tier') do
        get :following_by_tier, :profile_id => anybody, :tier => 3
      end
      should_be_allowed('to view a user\'s followers list') do
        get :followers, :profile_id => anybody
      end
      should_be_allowed('to view a user\'s friends list') do
        get :friends, :profile_id => anybody
      end
      should_be_unauthorized('to add someone to a user\'s following list') do
        post :follow, :profile_id => anybody, :follow_profile_id => :anything
      end
    end
  
    context 'A logged-in user' do
      setup do
        login_as :jack
      end

      should_be_forbidden('from viewing another user\'s following list by tier') do
        get :following_by_tier, :profile_id => somebody_other_than(current_profile), :tier => 3
      end
      should_be_forbidden('from adding someone to another user\'s following list') do
        post :follow, :profile_id => somebody_other_than(current_profile), :follow_profile_id => :anything
      end
      should_be_forbidden('from removing someone to another user\'s following list') do
        post :unfollow, :profile_id => somebody_other_than(current_profile), :follow_profile_id => :anything
      end
      should_be_forbidden('from moving someone on another user\'s following list to a different tier') do
        post :move_to_tier, :profile_id => somebody_other_than(current_profile), :follow_profile_id => :anything, :tier => 3
      end
      
      
      should_be_allowed('to view his own following list') do
        get :following, :profile_id => current_profile
      end
      
      should_be_allowed('to view another user\'s following list') do
        get :following, :profile_id => somebody_other_than(current_profile)
      end
      
      should_be_allowed('to view his own following list by tier') do
        get :following_by_tier, :profile_id => current_profile, :tier => 1
      end
      
      should_not_find 'his own following list for an invalid tier' do
        get :following_by_tier, :profile_id => current_profile, :tier => 4
      end
      
      should_be_allowed('to view his own followers list') do
        get :followers, :profile_id => current_profile
      end
      
      should_be_allowed('to view another user\'s followers list') do
        get :followers, :profile_id => somebody_other_than(current_profile)
      end
      
      should_be_allowed('to view his own friends list') do
        get :friends, :profile_id => current_profile
      end
      
      should_be_allowed('to view another user\'s friends list') do
        get :friends, :profile_id => somebody_other_than(current_profile)
      end
      
      should('be able to add someone to his following list') do
        @patrick = profiles(:patrick)
        assert !current_profile.following?(@patrick)
        assert_difference "current_profile.followees.size" do
          post :follow, :profile_id => current_profile, :follow_profile_id => @patrick
          assert_redirected_to :action => 'following'
        end
        assert current_profile.following?(@patrick)
      end
      
      should('be able to remove someone to his following list') do
        @other = current_profile.followees.first
        assert_difference "current_profile.followees.size", -1 do
          post :unfollow, :profile_id => current_profile, :follow_profile_id => @other
          assert_redirected_to :action => 'following'
        end
        assert !current_profile.following?(@other)
      end
      
      should('be able to move someone on his following list to a different tier') do
        f = current_profile.follower_friends.first
        old_tier = f.tier
        new_tier = ([1, 2] - [old_tier]).first
        post :move_to_tier, :profile_id => current_profile, :follow_profile_id => f.followee, :tier => new_tier
        assert_redirected_to :action => 'following_by_tier', :tier => new_tier
        assert !current_profile.followees.by_tier(old_tier).include?(f.followee)
        assert  current_profile.followees.by_tier(new_tier).include?(f.followee)
      end
      
      should 'not be able to move someone to an invalid tier' do
        post :move_to_tier, :profile_id => current_profile, :follow_profile_id => current_profile.followees.first, :tier => 5
        assert_response 400
        assert_template 'friends/following'
      end
      
    end
  
  end
  
end