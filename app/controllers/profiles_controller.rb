class ProfilesController < ApplicationController
  include ModelLoader
  
  before_filter :load_logged_in_profile
  before_filter :load_requested_profile, :only => [ :show, :edit, :update ]
  
  # GET only
  # requires logged_in? and is_self?
  def dashboard
  end
  
  # GET only
  # requires logged_in? and is_self?
  def getting_started
  end

  # GET only
  def show
  end

  # GET only
  # requires logged_in? and is_self?
  def edit
  end

  # POST only
  # requires logged_in? and is_self?
  def update
    redirect_to :action => 'show'
  end
  
  # GET or POST
  # requires logged_in? and is_self?
  def refer_a_friend
    if request.get?
    elsif request.post?
      redirect_to :dashboard
    end
  end
  
end
