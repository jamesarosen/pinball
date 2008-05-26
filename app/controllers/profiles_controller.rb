class ProfilesController < ApplicationController
  include ModelLoader
  
  before_filter :load_profile

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
