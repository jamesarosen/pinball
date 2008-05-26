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
  
end
