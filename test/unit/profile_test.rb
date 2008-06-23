require File.dirname(__FILE__) + '/../test_helper'

class ProfileTest < ActiveSupport::TestCase
  
  def setup
    @joan = profiles(:joan)
    @jack = profiles(:jack)
    @patrick = profiles(:patrick)
    @zoor = profiles(:zoor)
  end
  
  context 'A Profile instance' do
    should_belong_to :user
    should_belong_to :location
    should_ensure_length_in_range :email, 3..100
    should_allow_values_for :email, 'a@x.com', 'de.veloper@example.com', 'first.last+note@subdomain.example.com'
    should_not_allow_values_for :email, 'example.com', '@example.com', 'developer@example', 'developer', :message => 'is not a valid email address'
    should_require_unique_attributes :email
    should_allow_values_for :cell_carrier, nil, 'verizon', 'atandt', 't-mobile'
    should_not_allow_values_for :cell_carrier, 'foobar', :message => 'is not a valid cellular provider'
  end
  
  context 'An existing Profile' do
    
    should 'return their current location' do
      assert_equal locations(:lga), @jack.location
    end
    
    should 'be able to unset their current location' do
      assert_not_nil @jack.location
      @jack.location = nil
      @jack.save!
      assert_nil @jack.location
    end
    
    should 'be able to change their current location to a location' do
      original_loc = @jack.location
      @jack.location = locations(:orl)
      @jack.save!
      assert_not_equal original_loc, @jack.location
      assert_equal locations(:orl), @jack.location
    end
    
    should 'be able to change their current location to a string to be parsed' do
      @houston = locations(:houston_tx)
      Location.expects(:parse).with('anywhere').returns(@houston)
      
      original_loc = @jack.location
      @jack.location = 'anywhere'
      @jack.save!
      assert_not_equal original_loc, @jack.location
      assert_equal @houston, @jack.location
    end
    
    should 'not be able to change their current location to an unparseable string' do
      Location.expects(:parse).with('anywhere').raises(Location::ParseError.new('foo'))
      @jack.location = 'anywhere'
      assert !@jack.valid?
    end
    
    should 'be near a nearby profile' do
      @jack.location = @joan.location
      assert @jack.near?(@joan)
    end
    
    should 'not be near a far away profile' do
      assert !@jack.location.near?(@joan.location)
      assert !@jack.near?(@joan)
    end
    
    should 'not find anybody nearby if nobody is nearby' do
      assert_equal [], @jack.find_nearby(:include_self => false)
    end
    
    should 'find nearby people' do
      assert_equal [@joan], profiles(:zoor).find_nearby(:include_self => false)
    end
    
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