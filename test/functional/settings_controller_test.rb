require File.dirname(__FILE__) + '/../test_helper'

class SettingsControllerTest < ActionController::TestCase
  
  context 'The SettingsController: ' do
    
    context 'A guest' do
      should_be_unauthorized 'to view a user\'s privacy settings' do
        get :privacy, :profile_id => somebody_other_than(nil)
      end
      should_be_unauthorized 'to change a user\'s privacy settings' do
        post :privacy, :profile_id => somebody_other_than(nil)
      end
      should_be_unauthorized 'to view a user\'s notification settings' do
        get :notifications, :profile_id => somebody_other_than(nil)
      end
      should_be_unauthorized 'to change a user\'s notification settings' do
        post :notifications, :profile_id => somebody_other_than(nil)
      end
    end
  
    context 'A logged-in user' do
      setup do
        login_as :jack
      end
      
      should_be_forbidden 'from viewing another user\'s privacy settings' do
        get :privacy, :profile_id => somebody_other_than(current_user)
      end
      should_be_forbidden 'from changing another user\'s privacy settings' do
        post :privacy, :profile_id => somebody_other_than(current_user)
      end
      should_be_forbidden 'from viewing another user\'s notification settings' do
        get :notifications, :profile_id => somebody_other_than(current_user)
      end
      should_be_forbidden 'from changing another user\'s notification settings' do
        get :notifications, :profile_id => somebody_other_than(current_user)
      end
      
      should_be_allowed 'to view his privacy settings' do
        get :privacy, :profile_id => current_user
      end
      should_be_allowed 'to change his privacy settings' do
        post :privacy, :profile_id => current_user
        assert_response :success
      end
      should_be_allowed 'to view his notification settings' do
        get :notifications, :profile_id => current_user
      end
      should_be_allowed 'to change his notification settings' do
        post :notifications, :profile_id => current_user
      end
    end

  end  
  
end
