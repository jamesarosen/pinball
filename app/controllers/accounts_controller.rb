class AccountsController < ApplicationController
  
  append_before_filter :must_not_be_logged_in!, :except => [:logout]
  
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
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      remember_me! if params[:remember_me] == "1"
      redirect_back_or_default :controller => 'profiles', :profile_id => current_user, :action => 'dashboard'
    else
      flash[:error] = "Uh-oh, login didn't work. Do you have caps locks on? Try it again."
      redirect_to :action => 'login'
    end
  end

  # POST only
  def password_signup
    params[:user] ||= {}
    u = User.new(params[:user].pass(:terms_of_service, :login, :password, :password_confirmation, :email))
    if u.save
      remember_me if params[:remember_me] == "1"
      self.current_user = u
      flash[:notice] = 'Thanks for signing up!'
      redirect_to :controller => 'profiles', :profile_id => current_user, :action => 'getting_started'
    else
      @user = u
      params[:user][:password] = params[:user][:password_confirmation] = ''
      signup_form(:password)
    end
  end

  def logout
    self.current_user = nil
    redirect_to :controller => 'static', :action => 'welcome'
  end
  
  private
  
  def must_not_be_logged_in!
    if logged_in?
      flash[:warning] = 'You are already logged in'
      redirect_to :controller => 'profiles', :action => 'dashboard', :profile_id => current_user
    else
      true
    end
  end
  
  def remember_me!
    self.user.remember_me
    cookies[:auth_token] = {
      :value => self.user.remember_token,
      :expires => self.user.remember_token_expires_at
    }
  end
  
  def redirect_back_or_default(default)
    redirect_to (return_to_after_login_location ? return_to_after_login_location : default)
    self.return_to_after_login_location = nil
  end
  
  def login_form(type = :password)
    @type = type
    render :action => 'login'
  end
  
  def signup_form(type = :password)
    @type = type
    render :action => 'signup'
  end
  
end