require File.dirname(__FILE__) + '/../test_helper'

class ProfileTest < ActiveSupport::TestCase
  
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
    setup do
      @jack = profiles(:jack)
      @joan = profiles(:joan)
    end
    
    should 'return their current location' do
      assert_equal locations(:lga), @jack.location
    end
    
    should 'be able to unset their current location' do
      assert_not_nil @jack.location
      @jack.location = nil
      @jack.save!
      assert_nil @jack.location
    end
    
    should 'be able to change their current location' do
      original_loc = @jack.location
      @jack.location = locations(:orl)
      @jack.save!
      assert_not_equal original_loc, @jack.location
      assert_equal locations(:orl), @jack.location
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
    
  end
  
end