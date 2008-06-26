require File.dirname(__FILE__) + '/../test_helper'

class AccountsControllerTest < ActionController::TestCase
  
  VALID_PASSWORD_SIGNUP = {
    :login => 'quire',
    :email => 'quire@example.com',
    :password => 'quire',
    :password_confirmation => 'quire',
    :terms_of_service=>'1'
  }
  
  context 'The AccountsController: ' do

    context 'A visitor' do
      should_be_allowed 'to see the signup page' do
        get :signup
      end
      should 'be able to signup with a password' do
        assert_difference 'User.count' do
          post :password_signup, { :user => VALID_PASSWORD_SIGNUP }
          assert logged_in?
          assert_redirected_to :controller => 'profiles', :action => 'getting_started', :profile_id => current_user
          assert_equal 'Thanks for signing up!', flash[:notice]
        end
      end
      should 'not be able to signup without a login name' do
        assert_no_difference 'User.count' do
          post :password_signup, { :user => VALID_PASSWORD_SIGNUP.block(:login) }
          assert !logged_in?
        end
      end
      should 'not be able to signup with someone else\'s login name' do
        assert_no_difference 'User.count' do
          post :password_signup, { :user => VALID_PASSWORD_SIGNUP.merge(:login => anybody.login ) }
          assert !logged_in?
        end
      end
      should 'not be able to signup without an email address' do
        assert_no_difference 'User.count' do
          post :password_signup, { :user => VALID_PASSWORD_SIGNUP.block(:email) }
          assert !logged_in?
        end
      end
      should 'not be able to signup without a password' do
        assert_no_difference 'User.count' do
          post :password_signup, { :user => VALID_PASSWORD_SIGNUP.block(:password) }
          assert !logged_in?
        end
      end
      should 'not be able to signup without a password confirmation' do
        assert_no_difference 'User.count' do
          post :password_signup, { :user => VALID_PASSWORD_SIGNUP.block(:password_confirmation) }
          assert !logged_in?
        end
      end
      should 'not be able to signup without correctly confirming the passowrd' do
        assert_no_difference 'User.count' do
          post :password_signup, { :user => VALID_PASSWORD_SIGNUP.merge(:password_confirmation => 'something wrong') }
          assert !logged_in?
        end
      end
      should 'not be able to signup without accepting the terms of service' do
        assert_no_difference 'User.count' do
          post :password_signup, { :user => VALID_PASSWORD_SIGNUP.block(:terms_of_service) }
          assert !logged_in?, current_user.inspect
        end
      end
    end
  
    context 'A returning user' do
      should_be_allowed 'to see the login page' do
        get :login
      end
      should 'be able to login' do
        jack = users(:jack)
        post :password_login, :login => jack.login, :password => 'test'
        assert_redirected_to :controller => 'profiles', :profile_id => jack.id, :action => 'dashboard'
        assert logged_in?
        assert_equal jack, current_user
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
        assert !logged_in?
      end
    end
  
  end

end