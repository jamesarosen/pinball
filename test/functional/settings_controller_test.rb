require File.dirname(__FILE__) + '/../test_helper'

class SettingsControllerTest < ActionController::TestCase
  
  context 'The SettingsController: ' do
    
    context 'A guest' do
      should_be_unauthorized 'to view a user\'s privacy settings' do
        get :edit_privacy, :profile_id => anybody
      end
      should_be_unauthorized 'to change a user\'s privacy settings' do
        post :update_privacy, :profile_id => anybody
      end
      should_be_unauthorized 'to view a user\'s notification settings' do
        get :edit_notifications, :profile_id => anybody
      end
      should_be_unauthorized 'to change a user\'s notification settings' do
        post :update_notifications, :profile_id => anybody
      end
    end
  
    context 'A logged-in user' do
      setup do
        login_as :jack
      end
      
      should_be_forbidden 'from viewing another user\'s privacy settings' do
        get :edit_privacy, :profile_id => somebody_other_than(current_user)
      end
      should_be_forbidden 'from changing another user\'s privacy settings' do
        post :update_privacy, :profile_id => somebody_other_than(current_user)
      end
      should_be_forbidden 'from viewing another user\'s notification settings' do
        get :edit_notifications, :profile_id => somebody_other_than(current_user)
      end
      should_be_forbidden 'from changing another user\'s notification settings' do
        get :edit_notifications, :profile_id => somebody_other_than(current_user)
      end
      
      should_be_allowed 'to view his privacy settings' do
        get :edit_privacy, :profile_id => current_user
      end
      
      should 'be able to change his privacy settings' do
        assert_not_equal HasPrivacy::Authorization::SELF, current_user.profile.get_setting(Setting::PRIVACY_VIEW_CELL_PHONE)
        post :update_privacy, { :profile_id => current_user, :commit => 'Update', Setting::PRIVACY_VIEW_CELL_PHONE => HasPrivacy::Authorization::SELF.to_param }
        assert_equal HasPrivacy::Authorization::SELF, current_user.profile.get_setting(Setting::PRIVACY_VIEW_CELL_PHONE)
        assert_response :success
      end
      
      should 'not be able to change a privacy setting to an invalid value' do
        post :update_privacy, { :profile_id => current_user, :commit => 'Update', Setting::PRIVACY_VIEW_CELL_PHONE => 'foobar' }
        assert_response 400
      end
      
      should_be_allowed 'to view his notification settings' do
        get :edit_notifications, :profile_id => current_user
      end
      
      should_be_allowed 'to change his notification settings' do
        post :update_notifications, :profile_id => current_user
      end
    end

  end  
  
end
