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
      Location.expects(:parse).with('houston', @jack.favorite_locations).returns(@houston)
      
      original_loc = @jack.location
      @jack.location = 'houston'
      @jack.save!
      assert_not_equal original_loc, @jack.location
      assert_equal @houston, @jack.location
    end
    
    should 'not be able to change their current location to an unparseable string' do
      Location.expects(:parse).with('anywhere', @jack.favorite_locations).raises(Location::ParseError.new('foo'))
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
  
  context 'A Profile with a Favorite Location' do
    
    setup do
      @jack_home = favorite_locations(:jack_home)
      @fifth_ave = locations(:twelve_hundred_fifth_ave_new_nork_city)
    end
    
    should 'be able to set his location to a favorite' do
      assert_not_equal @jack_home.location, @jack.location
      @jack.location = 'home'
      assert_equal @jack_home.location, @jack.location
    end
    
    should "not be able to set his location to someone else's favorite" do
      mock_parser = Location::Parser.new
      mock_parser.expects(:parse_address).with('work').returns(nil)
      Location::Parser.expects(:new).returns(mock_parser)
      assert_nil @jack.favorite_locations.find_by_name('work')
      @jack.location = 'work'
      assert !@jack.valid?
    end
    
    should 'be able to add a favorite location' do
      assert_nil @jack.favorite_locations.find_by_name('nyc')
      assert_difference('@jack.favorite_locations.size', 1) do
        assert @jack.favorite_locations.create(:location => locations(:new_york_ny), :name => 'nyc').valid?
        @jack.reload
      end
    end
    
    should "be able to add a favorite with the same name as somebody else's" do
      @work = @joan.favorite_locations.find_by_name('work')
      assert_nil @jack.favorite_locations.find_by_name(@work.name)
      assert_difference('@jack.favorite_locations.size', 1) do
        assert @jack.favorite_locations.create(:location => locations(:london_england), :name => @work.name).valid?
        @jack.reload
      end
    end
    
    should 'not be able to add a favorite location with the same name as an existing one' do
      @home = @jack.favorite_locations.find_by_name('home')
      assert_difference('@jack.favorite_locations.size', 0) do
        assert !@jack.favorite_locations.create(:location => locations(:london_england), :name => @home.name).valid?
        @jack.reload
      end
    end
    
  end
  
end