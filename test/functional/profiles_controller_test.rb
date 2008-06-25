require File.dirname(__FILE__) + '/../test_helper'

class ProfilesControllerTest < ActionController::TestCase
  
  context 'A user' do
    should_not_find 'a non-existent profile' do
      assert_nil Profile.find_by_id(999)
      get :show, :profile_id => '999'
    end
  end
  
  context 'A guest' do
    should_be_allowed 'to view a user\'s profile if the user says so' do
      p = anybody.profile
      p.set_setting(Setting::PRIVACY_VIEW_PROFILE, HasPrivacy::Authorization::EVERYONE)
      get :show, :profile_id => p
    end
    should_be_unauthorized 'to view a user\'s profile if the user says so' do
      p = anybody.profile
      p.set_setting(Setting::PRIVACY_VIEW_PROFILE, HasPrivacy::Authorization::LOGGED_IN)
      get :show, :profile_id => p
    end
    should_be_unauthorized 'to view a user\'s dashboard' do
      get :dashboard, :profile_id => anybody
    end
    should_be_unauthorized 'to view a user\'s getting started page' do
      get :getting_started, :profile_id => anybody
    end
    should_be_unauthorized 'to update a user\'s profile' do
      post :update, :profile_id => anybody
    end
    should_be_unauthorized 'to refer a friend on behalf of a user' do
      post :refer_a_friend, :profile_id => anybody
    end
  end
  
  context 'A logged-in user' do
    setup do
      login_as :joan
    end
    
    should_be_forbidden 'from viewing another user\'s dashboard' do
      get :dashboard, :profile_id => somebody_other_than(current_user)
    end
    should_be_forbidden 'from viewing another user\'s getting started page' do
      get :getting_started, :profile_id => somebody_other_than(current_user)
    end
    should_be_forbidden 'from updting another user\'s profile' do
      post :update, :profile_id => somebody_other_than(current_user)
    end
    should_be_forbidden 'from referring a friend on behalf of another user' do
      post :refer_a_friend, :profile_id => somebody_other_than(current_user)
    end
    
    should_be_allowed 'to view her dashboard' do
      get :dashboard, :profile_id => current_user
    end
    
    should_be_allowed 'to view her getting_started page' do
      get :getting_started, :profile_id => current_user
    end
    
    should_be_allowed 'to view her own profile' do
      get :show, :profile_id => current_user
    end
    
    should_be_allowed 'to view the form to edit her profile' do
      get :edit, :profile_id => current_user
    end
    
    should 'have her current cell provider pre-selected' do
      current_user.profile.cell_carrier = 'verizon'
      current_user.save!
      get :edit, :profile_id => current_user
      assert_select 'option', :attributes => { :value => 'verizon', :selected => 'selected' }, :child => 'Verizon'
    end
    
    should 'be able to edit her profile' do
      assert_nil Profile.find_by_email('new.email.address@example.com')
      post :update, :profile_id => current_user, :profile => { :email => 'new.email.address@example.com', :display_name => 'new display name' }
      assert_response :redirect
      assert_redirected_to :action => 'show'
      assert_equal 'new.email.address@example.com', current_user.profile.email
      assert_equal 'new display name', current_user.profile.display_name
    end
    
    should 'not be able to erase her email address' do
      old_email = current_user.profile.email
      post :update, :profile_id => current_user, :profile => {:email => ''}
      assert_template 'profiles/edit'
      assert_equal old_email, current_user.profile.email
    end
    
    should 'not be able to change her email address to someone else\'s' do
      old_email = current_user.profile.email
      post :update, :profile_id => current_user, :profile => { :email => somebody_other_than(current_user).profile.email }
      assert_template 'profiles/edit'
      assert_equal old_email, current_user.profile.email
    end
    
    should 'be able to update her password' do
      post :update, :profile_id => current_user, :old_password => 'test', :new_password => 'not test', :new_password_confirmation => 'not test'
      assert_redirected_to :action => 'show'
      assert_flash 'Your password has been changed'
      assert_nil User.authenticate(current_user.login, 'test')
      assert_equal current_user, User.authenticate(current_user.login, 'not test')
    end
    
    should_be_allowed 'to view another user\s profile if the user says so' do
      p = somebody_other_than(current_user).profile
      p.set_setting(Setting::PRIVACY_VIEW_PROFILE, HasPrivacy::Authorization::LOGGED_IN)
      get :show, :profile_id => p
    end
    
    should_be_forbidden 'from viewing another user\s profile if the user says so' do
      p = somebody_other_than(current_user).profile
      p.set_setting(Setting::PRIVACY_VIEW_PROFILE, HasPrivacy::Authorization::SELF)
      get :show, :profile_id => p
    end
    
    should_be_allowed 'to see the form to refer a friend' do
      get :refer_a_friend_form, :profile_id => current_user
    end
    
    should 'be able to refer a friend' do
      post :refer_a_friend, :profile_id => current_user
      assert_redirected_to :action => 'dashboard'
    end
  end
  
end
