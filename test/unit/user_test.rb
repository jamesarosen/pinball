require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase

  VALID_USER = {:password=>'123456', :password_confirmation=>'123456', :login=>'valid_user', :email=>'valid_user@example.com', :terms_of_service => '1'}

  context 'A User instance' do
    should_require_attributes :login, :password, :password_confirmation
    should_require_unique_attributes :login

    should_ensure_length_in_range :login, 3..40
    should_ensure_length_in_range :password, 4..40
    should_protect_attributes :is_admin
  end
  
  context 'A new User instance' do
    should 'be valid if the password and password confirmation matches' do
      assert User.new(VALID_USER).valid?
    end

    should 'be invalid if password confirmation does not match the password' do
      assert !User.new(VALID_USER.merge(:password => 'something else')).valid?
    end

    should 'be invalid without agreeing to the terms of service' do
      assert !User.new(VALID_USER.block(:terms_of_service)).valid?
      assert !User.new(VALID_USER.merge(:terms_of_service => '0')).valid?
    end
    
    should 'be inavlid with somebody else\'s email address' do
      assert !User.new(VALID_USER.merge(:email => anybody.profile.email)).valid?
    end
  end
  
  context 'An Existing User' do
    setup do
      @joan = users(:joan)
    end
    
    should 'be able to change their password' do
      assert !(original_crypted_password = @joan.crypted_password).nil?
      assert @joan.change_password('test', 'asdfg', 'asdfg')
      assert @joan.valid?
      assert_not_equal original_crypted_password, @joan.crypted_password
    end

    should 'require the correct current password in order to change password' do
      assert !(original_crypted_password = @joan.crypted_password).nil?
      assert !@joan.change_password('tedst', 'asdfg', 'asdfg')
      assert @joan.valid?
      assert_equal original_crypted_password, @joan.reload.crypted_password
    end

    should 'require a matching password confirmation to change password' do
      assert !(original_crypted_password = @joan.crypted_password).nil?
      assert !@joan.change_password('test', 'asdfg', 'asdfgd')
      assert @joan.valid?
      assert_equal original_crypted_password, @joan.reload.crypted_password
    end

    should 'reset password if forgotten' do
      assert !(original_crypted_password = @joan.crypted_password).nil?
      @joan.forgot_password!
      assert_not_equal original_crypted_password, @joan.reload.crypted_password
    end
    
    should 'be able to reset their password' do
      @joan.update_attributes(:password => 'new password', :password_confirmation => 'new password')
      assert_equal @joan, User.authenticate('joan', 'new password')
      assert_nil User.authenticate('joan', 'test')
    end

    should 'not rehash their password when updating non-password fields' do
      @joan.update_attributes(:login => 'not joan')
      assert_equal @joan, User.authenticate('not joan', 'test')
    end

    should 'be able to authenticate' do
      assert_equal @joan, User.authenticate('joan', 'test')
    end

    should 'be remembered' do
      @joan.remember_me!
      assert @joan.remember_token?
      assert_not_nil @joan.remember_token
      assert_not_nil @joan.remember_token_expires_at
    end
  end

end
