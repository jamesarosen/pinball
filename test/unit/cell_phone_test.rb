require File.dirname(__FILE__) + '/../test_helper'

class CellPhoneTest < Test::Unit::TestCase
  
  context 'An ActiveRecord including the CellPhone module' do
    setup do
      @profile = Profile.find(:first)
    end
    should 'define methods' do
      assert @profile.respond_to?(:cell_number)
      assert @profile.respond_to?(:cell_number=)
      assert @profile.respond_to?(:cell_carrier)
      assert @profile.respond_to?(:cell_carrier=)
      assert @profile.respond_to?(:can_sms_fu?)
    end
    should 'parse cell phone numbers' do
      @profile.cell_number = '(785) 555-1000'
      assert @profile.cell_number.kind_of?(CellPhone::Number)
      assert_equal '(785) 555-1000', @profile.cell_number.to_s
      assert_equal '7855551000', @profile.cell_number.sms_fu_number
    end
    should 'store formatted cell phone numbers' do
      @profile.cell_number = '(785) 555-1000'
      assert_equal '(785) 555-1000', @profile.read_attribute(:cell_number)
    end
    should 'erase cell phone numbers when passed a blank String' do
      @profile.cell_number = '(785) 555-1000'
      assert @profile.cell_number.kind_of?(CellPhone::Number)
      @profile.cell_number = ''
      assert_nil @profile.cell_number
    end
    should 'parse cell phone carriers' do
      @profile.cell_carrier = 't-mobile'
      assert @profile.cell_carrier.kind_of?(CellPhone::Carrier)
      assert_equal 'T-Mobile', @profile.cell_carrier.display_name
    end
    should 'store sms-fu-friendly cell phone carrier names' do
      @profile.cell_carrier = 'atandt'
      assert_equal 'atandt', @profile.read_attribute(:cell_carrier)
    end
    should 'validate that a carrier is a real carrier' do
      @profile.cell_carrier = 't-mobile'
      assert @profile.valid?
      
      @profile.cell_carrier = 'not-a-real-carrier'
      assert !@profile.valid?
    end
  end
  
  context 'A CellPhone::Number' do
    should 'retain formatting' do
      assert_equal '(617) 555-2000', CellPhone::Number.new('(617) 555-2000').to_s
    end
    
    should 'be equal if their sms_fu versions are equal' do
      assert_equal CellPhone::Number.new('(617) 555-2000'), CellPhone::Number.new('(617) 555-2000')
      assert_equal CellPhone::Number.new('(617) 555-2000'), CellPhone::Number.new('1.617.555.2000')
      assert_equal CellPhone::Number.new('(617) 555-2000'), CellPhone::Number.new('617.555.2000')
      assert_equal CellPhone::Number.new('(617) 555-2000'), CellPhone::Number.new('6175552000')
    end
    
    should 'not be equal if their sms_fu version differ' do
      assert_not_equal CellPhone::Number.new('(617) 555-2000'), CellPhone::Number.new('(617) 555-2001')
    end
    
    should 'convert to only digits for sms_fu' do
      assert_equal '6175552000', CellPhone::Number.new('(617) 555-2000').sms_fu_number
      assert_nil CellPhone::Number.new('(not a number').sms_fu_number
    end
    
    should 'remove leading 1 for sms_fu' do
      assert_equal '6175552000', CellPhone::Number.new('1-617-555-2000').sms_fu_number
    end
    
    should 'be able to sms_fu with a number' do
      assert CellPhone::Number.new('(617) 555-2000').can_sms_fu?
    end
    
    should 'not be able to sms_fu without any numbers' do
      assert !CellPhone::Number.new('not a number').can_sms_fu?
    end
  end
  
  context 'The CellPhone::Carrier class' do
    setup do
      @atandt = CellPhone::Carrier::CARRIERS.find { |c| c.display_name == 'AT&T' }
      @tmobile = CellPhone::Carrier::CARRIERS.find { |c| c.display_name == 'T-Mobile' }
      @verizon = CellPhone::Carrier::CARRIERS.find { |c| c.display_name == 'Verizon' }
    end
    should 'have existing known carriers' do
      assert_not_nil @atandt
      assert_not_nil @tmobile
      assert_not_nil @verizon
    end
    should 'parse to an existing instance if one matches by param' do
      assert_equal @atandt, CellPhone::Carrier.parse('atandt')
      assert_equal @tmobile, CellPhone::Carrier.parse('t-mobile')
      assert_equal @verizon, CellPhone::Carrier.parse('verizon')
    end
    should 'parse to an instance that can sms_fu if one matches by param' do
      assert CellPhone::Carrier.parse('atandt').can_sms_fu?
      assert CellPhone::Carrier.parse('t-mobile').can_sms_fu?
      assert CellPhone::Carrier.parse('verizon').can_sms_fu?
    end
    should 'return the argument to parse if none matches by param' do
      carrier = CellPhone::Carrier.parse('not-a-known-carrier')
      assert_not_nil carrier
      assert carrier.kind_of?(String)
      assert_equal 'not-a-known-carrier', carrier
    end
  end
  
end