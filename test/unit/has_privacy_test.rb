require File.dirname(__FILE__) + '/../test_helper'

class HasPrivacyTest < ActiveSupport::TestCase
  
  def setup
    @joan = profiles(:joan)
    @jack = profiles(:jack)
    @patrick = profiles(:patrick)
  end
  
  context 'A Profile with default privacy settings' do
    setup do
      assert @patrick.settings.size == 0
    end
    
    should 'allow the profile to appear in search results for everyone' do
      assert @patrick.allows?(Setting::PRIVACY_SEARCH_RESULT, nil)
    end
    
    should 'allow any logged-in user to view the profile' do
      assert !@patrick.allows?(Setting::PRIVACY_VIEW_PROFILE, nil)
      assert @patrick.allows?(Setting::PRIVACY_VIEW_PROFILE, 'anybody')
    end
    
    should 'allow followees to view email address' do
      assert !@patrick.allows?(Setting::PRIVACY_VIEW_EMAIL, @jack)
      assert @joan.allows?(Setting::PRIVACY_VIEW_EMAIL, @jack)
    end

    should 'allow followees to view cell phone' do
      assert !@patrick.allows?(Setting::PRIVACY_VIEW_CELL_PHONE, @jack)
      assert @joan.allows?(Setting::PRIVACY_VIEW_CELL_PHONE, @jack)
    end

    should 'allow followees to view followees' do
      assert !@patrick.allows?(Setting::PRIVACY_VIEW_FOLLOWEES, @jack)
      assert @joan.allows?(Setting::PRIVACY_VIEW_FOLLOWEES, @jack)
    end
  end
  
  context 'A Profile with a custom privacy setting' do
    setup do
      assert_equal HasPrivacy::Authorization::EVERYONE, @jack.get_setting(Setting::PRIVACY_VIEW_PROFILE)
    end
    
    should 'use the custom setting' do
      assert @jack.allows?(Setting::PRIVACY_VIEW_PROFILE, nil)
    end
  end
  
  context 'The available Authorizations' do
    
    context "'everyone'" do
      setup do
        @auth = HasPrivacy::Authorization['everyone']
      end
      
      should 'authorize nil' do
        assert @auth.authorized?(nil, @joan)
      end

      should 'authorize someone not following' do
        assert @auth.authorized?(@jack, @patrick)
      end
      
      should 'authorize someone following' do
        assert @auth.authorized?(@jack, @joan)
      end
      
      should 'authorize self' do
        assert @auth.authorized?(@jack, @jack)
      end
    end
    
    context "'logged_in'" do
      setup do
        @auth = HasPrivacy::Authorization['logged_in']
      end
      
      should 'not authorize nil' do
        assert !@auth.authorized?(nil, @joan)
      end

      should 'authorize someone not following' do
        assert @auth.authorized?(@jack, @patrick)
      end
      
      should 'authorize someone following' do
        assert @auth.authorized?(@jack, @joan)
      end
      
      should 'authorize self' do
        assert @auth.authorized?(@jack, @jack)
      end
    end
    
    context "'followees'" do
      setup do
        @auth = HasPrivacy::Authorization['followees']
      end
      
      should 'not authorize nil' do
        assert !@auth.authorized?(nil, @joan)
      end

      should 'not authorize someone not following' do
        assert !@auth.authorized?(@jack, @patrick)
      end
      
      should 'authorize someone following' do
        assert @auth.authorized?(@jack, @joan)
      end
      
      should 'authorize self' do
        assert @auth.authorized?(@jack, @jack)
      end
    end
    
    context "'tier_1'" do
      setup do
        @auth = HasPrivacy::Authorization['tier_1']
      end
      
      should 'not authorize nil' do
        assert !@auth.authorized?(nil, @joan)
      end

      should 'not authorize someone not following' do
        assert !@auth.authorized?(@jack, @patrick)
      end
      
      should 'not authorize someone following in tier 2' do
        assert !@auth.authorized?(@joan, @jack)
      end
      
      should 'authorize someone following in tier 1' do
        assert @auth.authorized?(@jack, @joan)
      end
      
      should 'authorize self' do
        assert @auth.authorized?(@jack, @jack)
      end
    end
    
    context "'tiers_1_2'" do
      setup do
        @auth = HasPrivacy::Authorization['tiers_1_2']
      end
      
      should 'not authorize nil' do
        assert !@auth.authorized?(nil, @joan)
      end

      should 'not authorize someone not following' do
        assert !@auth.authorized?(@jack, @patrick)
      end
      
      should 'not authorize someone following in tier 3' do
        assert !@auth.authorized?(@patrick, @joan)
      end
      
      should 'authorize someone following in tier 2' do
        assert @auth.authorized?(@joan, @jack)
      end
      
      should 'authorize self' do
        assert @auth.authorized?(@jack, @jack)
      end
    end
    
    context "'self'" do
      setup do
        @auth = HasPrivacy::Authorization['self']
      end
      
      should 'not authorize nil' do
        assert !@auth.authorized?(nil, @joan)
      end

      should 'not authorize someone not following' do
        assert !@auth.authorized?(@jack, @patrick)
      end
      
      should 'not authorize someone following' do
        assert !@auth.authorized?(@jack, @joan)
      end
      
      should 'authorize self' do
        assert @auth.authorized?(@jack, @jack)
      end
    end
    
  end
  
end