require File.dirname(__FILE__) + '/../test_helper'

class AddressLocationTest < ActiveSupport::TestCase
  
  def self.model_class; Location::Address; end
  
  VALID_ADDRESS = { :display_name => '128 Chestnut St., Garbunkle, ME', :latitude => -14.4, :longitude => 22.11124 }  
    
  def new_address(args = {})
    Location::Address.new(VALID_ADDRESS.merge(args))
  end
  
  def geocode_returns(options = {})
    loc = GeoKit::GeoLoc.new(options)
    loc.success = true if options[:success]
    GeoKit::Geocoders::MultiGeocoder.stubs(:geocode).returns(loc)
  end
  
  context 'Creating a new address with longitude and latitude' do
    
    setup do
      geocode_returns {}
    end
    
    should 'require a display_name' do
      assert !new_address(:display_name => nil).valid?
    end
    
    should 'require a valid longitude' do
      assert !new_address(:longitude => nil).valid?
      assert !new_address(:longitude => -180.55).valid?
      assert !new_address(:longitude => 180.123).valid?
    end
    
    should 'require a valid latitude' do
      assert !new_address(:latitude => nil).valid?
      assert !new_address(:latitude => -90.048).valid?
      assert !new_address(:latitude => 90.992).valid?
    end
    
    should 'be valid with a display_name, longitude and latitude' do
      a = new_address
      assert a.valid?, a.errors.inspect
    end
    
    should 'not geocode if latitude and longitude are speicified' do      
      GeoKit::Geocoders::MultiGeocoder.expects(:geocode).times(0)
      new_address
    end
  
    should "Always use 'Addrees' as the type" do
      assert_equal 'Address', new_address(:location_type => nil).location_type
      assert_equal 'Address', new_address(:location_type => 'wrong type').location_type
    end
    
  end

  context 'Creating a new address with geocoding' do
    
    should 'not geocode an empty address' do
      GeoKit::Geocoders::MultiGeocoder.expects(:geocode).times(0)
      a = new_address(:display_name => nil, :latitude => nil, :longitude => nil)
      assert_nil a.latitude
      assert_nil a.longitude
    end
    
    should 'geocode latitude and longitude' do
      geocode_returns({ :lat => 44.44, :lng => -55.55, :success => true })
      a = new_address(:latitude => nil, :longitude => nil)
      a.save
      a.reload
      assert_equal 44.44, a.latitude.to_f
      assert_in_delta -55.55, a.longitude.to_f, 0.00001
    end
    
    should 'be invalid if geocoding is necessary, but fails' do
      geocode_returns({ :success => false })
      a = new_address(:latitude => nil, :longitude => nil)
      assert !a.valid?
    end
    
  end
  
  context 'An existing address' do
    
    setup do
      @ny_ny = locations(:new_york_ny)
      @fifth_ave_ny = locations(:twelve_hundred_fifth_ave_new_nork_city)
      @houston_tx = locations(:houston_tx)
      @main_st_houston = locations(:nineteen_main_st_houston_tx)
      @london = locations(:london_england)
    end
    
    should 'be near itself' do
      assert_equal 0, @ny_ny.distance_to(@ny_ny)
      assert @houston_tx.near?(@houston_tx)
    end
    
    should 'be near addresses in the same city' do
      assert @ny_ny.near?(@fifth_ave_ny)
      assert @fifth_ave_ny.near?(@ny_ny)
      assert @houston_tx.near?(@main_st_houston)
      assert @main_st_houston.near?(@houston_tx)
    end
    
    should 'not be near addresses in other cities' do
      assert !@ny_ny.near?(@houston_tx)
      assert !@ny_ny.near?(@main_st_houston)
      assert !@ny_ny.near?(@london)
    end
    
    should 'not be near an airport in the same city' do
      assert !@ny_ny.near?(locations(:lga))
    end
    
    should 'find nearby addresses' do
      assert_equal [@fifth_ave_ny], @ny_ny.find_nearby
    end
    
  end
  
end