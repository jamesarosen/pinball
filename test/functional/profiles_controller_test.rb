require File.dirname(__FILE__) + '/../test_helper'

class ProfilesControllerTest < ActionController::TestCase
  
  context 'A guest' do
    should_be_allowed 'to view a user\'s profile' do
      get :show, :profile_id => anybody
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
    
    should_be_allowed 'to view another user\s profile' do
      get :show, :profile_id => somebody_other_than(current_user)
    end
    
    should_be_allowed 'to see the form to refer a friend' do
      get :refer_a_friend, :profile_id => current_user
    end
    
    should 'be able to refer a friend' do
      post :refer_a_friend, :profile_id => current_user
      assert_redirected_to :action => 'dashboard'
    end
  end
  
end
