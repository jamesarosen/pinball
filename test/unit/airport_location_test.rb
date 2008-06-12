require File.dirname(__FILE__) + '/../test_helper'

class AirportLocationTest < ActiveSupport::TestCase
  
  def self.model_class; Location::Airport; end
  
  context 'Creating a new airport' do
  end
  
  context 'An existing airport' do
    
    setup do
      @pit = locations(:pit)
      @lga = locations(:lga)
      @jfk = locations(:jfk)
    end
    
    should 'be near itself' do
      assert @pit.near?(@pit)
    end
    
    should 'not be near another airport' do
      assert !@pit.near?(@lga)
    end
    
    should 'not be near another airport, even in the same city' do
      assert !@lga.near?(@jfk)
    end
    
  end
  
end