require File.dirname(__FILE__) + '/../test_helper'

class AccountsControllerTest < ActionController::TestCase
  
  VALID_PASSWORD_SIGNUP = {
    
  }
  
  context 'The AccountsController: ' do

    context 'A visitor' do
      should_be_allowed 'to see the signup page' do
        get :signup
      end
      should 'be able to signup with a password' do
        #assert_difference "User.count" do
          post :password_signup, { :user => VALID_PASSWORD_SIGNUP }
          assert_redirected_to :controller => 'profiles', :action => 'getting_started'
          assert_equal 'Thanks for signing up!', flash[:notice]
        #end
      end
    end
  
    context 'A returning user' do
      should_be_allowed 'to see the login page' do
        get :login
      end
      should 'be able to login' do
        post :password_login, :login => 'jack', :password => 'test'
        assert_redirected_to :controller => 'profiles', :profile_id => User.find(:first), :action => 'dashboard'
        assert logged_in?
      end
    end
  
    context 'A logged-in user' do
      setup do
        login_as :jack
      end
      should 'be able to log out' do
        get :logout
        assert_response :redirect
        assert_redirected_to :controller => 'static', :action => 'welcome'
      end
    end
  
  end

end