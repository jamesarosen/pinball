require File.dirname(__FILE__) + '/../test_helper'

class FriendshipTest < ActiveSupport::TestCase
  
  def setup
    @joan = profiles(:joan)
    @jack = profiles(:jack)
    @patrick = profiles(:patrick)
    @jack_joan = friendships(:jack_joan)
    @joan_jack = friendships(:joan_jack)
    @joan_patrick = friendships(:joan_patrick)
  end
  
  context 'The Friendship class' do
    should 'find friendships by tier' do
      assert_equal [@joan_jack], Friendship.by_tier(1)
      assert_equal [@jack_joan], Friendship.by_tier(2)
      assert_equal [@joan_patrick], Friendship.by_tier(3)
    end
    
    should 'find mutual friendships' do
      fs = Friendship.mutual
      assert_equal 2, fs.size
      assert fs.include?(@jack_joan)
      assert fs.include?(@joan_jack)
    end
  end
  
  context 'A Friendship instance' do
    should_belong_to :follower
    should_belong_to :followee
    should_allow_values_for :tier, '1', '2', '3', 1, 2, 3
    should_not_allow_values_for :tier, '0', '4', '-1', 0, 4, -1
    
    should 'be invalid if follower and followee are the same' do
      f = Friendship.new(:follower => @joan, :followee => @joan)
      assert !f.valid?
      assert f.errors.on(:follower)
    end
    
    should 'be invalid if follower is already following followee' do
      assert_not_nil Friendship.find_friendship(@joan, @patrick)
      f = Friendship.new(:follower => @joan, :followee => @patrick)
      assert !f.valid?
      assert f.errors.on(:followee)
    end
    
    should 'coerce non-integer tiers to integer ones' do
      f = Friendship.new(:follower => @patrick, :followee => @jack, :tier => 2.2)
      f.save!
      assert_equal 2, f.tier
    end
  end
  
  context 'An existing Friendship' do
    
    should 'know whether it is mutual' do
      assert @jack_joan.mutual?
      assert @joan_jack.mutual?
      assert !@joan_patrick.mutual?
    end
    
  end
  
end