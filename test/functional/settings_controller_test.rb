require File.dirname(__FILE__) + '/../test_helper'

class SettingsControllerTest < ActionController::TestCase
  
  context 'A logged-in user' do
    setup do
      login_as :foo
    end
    should 'be able to view privacy settings' do
      get :privacy, :profile_id => :foo
      assert_response :success
    end
    should 'be able to edit privacy settings' do
      post :privacy, :profile_id => :foo
      assert_response :success
    end
    should 'be able to view notification settings' do
      get :notifications, :profile_id => :foo
      assert_response :success
    end
    should 'be able to edit notification settings' do
      post :notifications, :profile_id => :foo
      assert_response :success
    end
  end
  
end
