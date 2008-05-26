class ProfilesController < ApplicationController
  include ModelLoader
  
  before_filter :load_profile

  # GET only
  def show
  end

  # GET only
  # requires login
  # requires logged in as self
  def edit
  end

  # POST only
  # requires login
  # requires logged in as self
  def update
    redirect_to :action => 'show'
  end
  
end
