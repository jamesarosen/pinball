require File.dirname(__FILE__) + '/../test_helper'

class LocationParserTest < ActiveSupport::TestCase
  include Location
  
  def setup
    @parser = Parser.new
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
  
  def test_returns_airport_from_code
    assert_equal locations(:pit), @parser.parse('PIT')
  end

  def test_returns_airport_from_lowercase_code
    assert_equal locations(:pit), @parser.parse('pit')
  end
  
  def test_returns_airport_from_alias
    assert_equal locations(:pit), @parser.parse('Pittsburgh airport')
  end
  
end