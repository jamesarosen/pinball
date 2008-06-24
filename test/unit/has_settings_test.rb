require File.dirname(__FILE__) + '/../test_helper'

class HasSettingsTest < ActiveSupport::TestCase
  
  def setup
    @joan = profiles(:joan)
    @jack = profiles(:jack)
  end

  context 'A Profile without a Setting' do
    
    setup do
      assert_nil @joan.find_setting(Setting::PRIVACY_VIEW_FOLLOWEES)
    end
    
    should 'return nil for find_setting' do
      assert_nil @joan.find_setting(Setting::PRIVACY_VIEW_FOLLOWEES)
    end
    
    should 'return the default setting for get_setting' do
      assert_equal HasPrivacy::Authorization::LOGGED_IN, @joan.get_setting(Setting::PRIVACY_VIEW_FOLLOWEES)
    end
    
    should "create a new setting when setting the setting" do
      assert_difference('@joan.settings.size', 1) do
        @joan.set_setting(Setting::PRIVACY_VIEW_PROFILE, HasPrivacy::Authorization::FOLLOWEES)
      end
    end
    
    should 'not be able to create a setting with an invalid name' do
      assert_raises(ActiveRecord::RecordInvalid) do
        @joan.set_setting('foobar', HasPrivacy::Authorization::TIER_1_FOLLOWEES)
      end
    end
    
    should 'not be able to create a setting to an invalid value' do
      assert_raises(ActiveRecord::RecordInvalid) do
        @joan.set_setting(Setting::PRIVACY_VIEW_FOLLOWEES, 'baz')
      end
    end
    
  end
  
  context 'A Profile with a Setting' do
    
    setup do
      assert_not_nil @jack.find_setting(Setting::PRIVACY_VIEW_PROFILE)
    end
    
    should 'return the setting for find_setting' do
      s = @jack.find_setting(Setting::PRIVACY_VIEW_PROFILE)
      assert s.kind_of?(Setting)
      assert_equal Setting::PRIVACY_VIEW_PROFILE, s.name
    end
    
    should 'return the setting value for get_setting' do
      assert_equal HasPrivacy::Authorization::EVERYONE, @jack.get_setting(Setting::PRIVACY_VIEW_PROFILE)
    end
    
    should 'not create a new Setting when updating' do
      assert_not_nil @jack.find_setting(Setting::PRIVACY_VIEW_PROFILE)
      assert_difference('@jack.settings.size', 0) do
        @jack.set_setting(Setting::PRIVACY_VIEW_PROFILE, HasPrivacy::Authorization::FOLLOWEES)
      end
    end
    
    should 'update a setting' do
      assert_not_equal HasPrivacy::Authorization::TIER_1_FOLLOWEES, @jack.get_setting(Setting::PRIVACY_VIEW_PROFILE)
      @jack.set_setting(Setting::PRIVACY_VIEW_PROFILE, HasPrivacy::Authorization::TIER_1_FOLLOWEES)
      assert_equal HasPrivacy::Authorization::TIER_1_FOLLOWEES, @jack.get_setting(Setting::PRIVACY_VIEW_PROFILE)
    end
    
    should 'not be able to update a setting to an invalid value' do
      assert_raises(ActiveRecord::RecordInvalid) do
        @jack.set_setting(Setting::PRIVACY_VIEW_PROFILE, 'baz')
      end
    end
    
  end
  
end