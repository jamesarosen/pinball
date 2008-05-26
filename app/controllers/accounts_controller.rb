class AccountsController < ApplicationController
  
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
    redirect_to :controller => 'profiles', :action => 'dashboard'
  end

  # POST only
  def password_signup
    flash[:notice] = 'Thanks for signing up!'
    redirect_to :controller => 'profiles', :action => 'getting_started'
  end

  def logout
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