require File.dirname(__FILE__) + '/../test_helper'

class SettingTest < ActiveSupport::TestCase
  
  VALID_SETTING = { :name => Setting::PRIVACY_VIEW_PROFILE, :value => Authorization::FOLLOWEES }
  
  def setup
    @joan = profiles(:joan)
    @jack = profiles(:jack)
    @patrick = profiles(:patrick)
  end

  context 'A Setting instance' do
    should_require_attributes :profile, :name, :value
    should_allow_values_for :name, *Setting::ALLOWED_SETTINGS.keys
    should_not_allow_values_for :name, 'foo', :message => /not a valid/
  end
  
  context 'A new Setting instance' do
    should 'be valid if the Profile does not already have a Setting of the same name' do
      assert @joan.settings.empty?
      assert Setting.new(VALID_SETTING.merge(:profile => @joan)).valid?
    end
    
    should 'be invalid if the Profile already has a Setting of the same name' do
      s = @jack.settings.first
      assert_not_nil s
      assert Setting.valid_setting_value?(s.name, Authorization::TIERS_1_2_FOLLOWEES)
      assert !Setting.new(:profile => @jack, :name => s.name, :value => Authorization::TIERS_1_2_FOLLOWEES).valid?
    end
    
    should 'be invalid with an invalid setting value for the given name' do
      assert !Setting.new(VALID_SETTING.merge(:profile => @joan, :value => 'foo')).valid?
    end
    
  end
  
end