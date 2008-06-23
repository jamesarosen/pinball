require File.dirname(__FILE__) + '/../test_helper'

class FriendshipnessTest < ActiveSupport::TestCase
  
  def setup
    @joan = profiles(:joan)
    @jack = profiles(:jack)
    @patrick = profiles(:patrick)
    @zoor = profiles(:zoor)
  end
  
  context 'An existing Profile with friends' do
    
    should 'list friends' do
      assert_equal [@joan], @jack.friends
      assert_equal [@jack], @joan.friends
      assert_equal [], @patrick.friends
    end
    
    should 'list followees' do
      assert_equal [@joan], @jack.followees
      assert_equal [@jack, @patrick], @joan.followees.sort { |x,y| x.id <=> y.id }
      assert_equal [], @patrick.followees
    end
    
    should 'list followees by tier' do
      assert_equal [@jack], @joan.followees.by_tier(1)
      assert_equal [], @joan.followees.by_tier(2)
      assert_equal [@patrick], @joan.followees.by_tier(3)
    end
    
    should 'list followers' do
      assert_equal [@joan], @jack.followers
      assert_equal [@jack], @joan.followers
      assert_equal [@joan], @patrick.followers
    end
    
    should 'list followers by tier' do
      assert_equal [@joan], @jack.followers.by_tier(1)
      assert_equal [], @jack.followers.by_tier(2)
      assert_equal [], @jack.followers.by_tier(3)
    end
    
    should 'know whether is friends with another' do
      assert @joan.friends_with?(@jack)
      assert @jack.friends_with?(@joan)
      
      assert !@jack.friends_with?(@patrick)
      assert !@patrick.friends_with?(@jack)
    
      assert !@joan.friends_with?(@patrick)
      assert !@patrick.friends_with?(@joan)
    end
    
    should 'know whether is following another' do
      assert @joan.following?(@jack)
      assert @jack.following?(@joan)
      
      assert !@jack.following?(@patrick)
      assert !@patrick.following?(@jack)
    
      assert @joan.following?(@patrick)
      assert !@patrick.following?(@joan)
    end
    
    should 'know whether is following another in a tier or set of tiers' do
      assert @joan.following_in_tiers?(@jack, 1)
      assert @joan.following_in_tiers?(@jack, 1, 2)
      assert @joan.following_in_tiers?(@jack, 1, 2, 3)
      
      assert !@joan.following_in_tiers?(@patrick, 1)
      assert !@joan.following_in_tiers?(@patrick, 1, 2)
      assert @joan.following_in_tiers?(@patrick, 1, 2, 3)
      
      assert !@jack.following_in_tiers?(@patrick, 1)
      assert !@jack.following_in_tiers?(@patrick, 1, 2)
      assert !@jack.following_in_tiers?(@patrick, 1, 2, 3)
    end
    
    should 'know whether is followed by another' do
      assert @joan.followed_by?(@jack)
      assert @jack.followed_by?(@joan)
      
      assert !@jack.followed_by?(@patrick)
      assert !@patrick.followed_by?(@jack)
    
      assert !@joan.followed_by?(@patrick)
      assert @patrick.followed_by?(@joan)
    end
    
    should 'follow somebody' do
      @jack.follow!(@patrick)
      
      assert @jack.followees(true).include?(@patrick)
      assert @jack.following?(@patrick)
    end
    
    should 'become friends on following a follower' do
      assert @joan.following?(@patrick)
      @patrick.follow!(@joan)
      
      assert @joan.friends_with?(@patrick)
      assert @patrick.friends_with?(@joan)
    end
    
    should 'unfollow somebody' do
      assert @joan.following?(@patrick)
      @joan.unfollow!(@patrick)
      assert !@joan.following?(@patrick)
    end
    
    should 'stop being friends after unfollowing somebody' do
      assert @joan.friends_with?(@jack)
      @joan.unfollow!(@jack)
      @joan.friends(true) and @jack.friends(true)
      assert !@joan.friends_with?(@jack)
      assert !@jack.friends_with?(@joan)
    end
    
    should 'move somebody to a different following tier' do
      assert_equal [@joan], @jack.followees.by_tier(2)
      assert_equal [], @jack.followees.by_tier(1)
      @jack.move_to_tier!(@joan, 1)
      assert_equal [], @jack.followers.by_tier(2)
      assert_equal [@joan], @jack.followers.by_tier(1)
    end
    
    should "not be able to 'move' somebody to the same tier" do
      assert_equal [@joan], @jack.followees.by_tier(2)
      assert_raises(ActiveRecord::RecordInvalid) { @jack.move_to_tier!(@joan, 2) }
    end
    
  end
  
end