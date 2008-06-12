require File.dirname(__FILE__) + '/../test_helper'

class LocationParserTest < ActiveSupport::TestCase
  include Location
  
  def setup
    @parser = Parser.new
    GeoKit::Geocoders::MultiGeocoder.stubs(:geocode).returns(GeoKit::GeoLoc.new)
  end
  
  def test_returns_airport_instance
    airport = Location::Airport.find(:first)
    assert_not_nil airport
    assert_equal airport, @parser.parse(airport)
  end
  
  def test_returns_address_instance
    address = Location::Address.find(:first)
    assert_not_nil address
    assert_equal address, @parser.parse(address)
  end
  
  def test_returns_existing_airport_from_code
    assert_equal locations(:pit), @parser.parse('PIT')
  end

  def test_returns_existing_airport_from_lowercase_code
    assert_equal locations(:pit), @parser.parse('pit')
  end
  
  def test_returns_existing_airport_from_alias
    assert_equal locations(:pit), @parser.parse('Pittsburgh airport')
  end
  
  def test_returns_new_airport_from_code
    assert_nil Location::Airport.find_by_display_name('BBM')
    a = @parser.parse('BBM')
    assert_not_nil a
    assert !a.new_record?
    assert_equal 'BBM', a.display_name
  end
  
  def test_returns_new_airport_from_alias
    assert_nil Location::Airport.find_by_display_name('BOI')
    a = @parser.parse('boise airport')
    assert_not_nil a
    assert !a.new_record?
    assert_equal 'BOI', a.display_name
  end
  
  def test_cannot_parse_invalid_airport_code
    assert !@parser.airport_aliases.values.include?('BOT')
    assert_raises(Location::ParseError) { @parser.parse 'BOT' }
  end
  
end