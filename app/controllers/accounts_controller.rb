class AccountsController < ApplicationController
  
  attr_reader :type
  
  # GET only
  def login
    login_form(:password)
  end
  
  # GET only
  def signup
    signup_form(:password)
  end

  # POST only
  def password_login
    current_user = User.find(:first)
    redirect_to :controller => 'profiles', :profile_id => current_user, :action => 'dashboard'
  end

  # POST only
  def password_signup
    current_user = User.find(:first)
    flash[:notice] = 'Thanks for signing up!'
    redirect_to :controller => 'profiles', :profile_id => current_user, :action => 'getting_started'
  end

  def logout
    current_user = nil
    redirect_to :controller => 'static', :action => 'welcome'
  end
  
  private
  
  def login_form(type = :password)
    @type = type
    render :action => 'login'
  end
  
  def signup_form(type = :password)
    @type = type
    render :action => 'signup'
  end
  
end