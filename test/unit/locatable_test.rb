require File.dirname(__FILE__) + '/../test_helper'

class LocatableTest < ActiveSupport::TestCase
  
  def setup
    @joan = profiles(:joan)
    @jack = profiles(:jack)
    @patrick = profiles(:patrick)
    @zoor = profiles(:zoor)
  end
  
  context 'An existing Profile with a Location' do
    
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
    
  end
  
end