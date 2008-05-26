class FavoriteLocationsController < ApplicationController
  
  include ModelLoader
  
  before_filter :load_logged_in_profile
  before_filter :load_requested_profile
  before_filter :load_requested_favorite_location, :only => [ :edit, :delete, :update ]
  
  # GET only
  # requires logged_in? and is_self?
  def list
  end

  # GET only
  # requires logged_in? and is_self?
  def add
  end
  
  # POST only
  # requires logged_in? and is_self?
  def create
    redirect_to :action => 'list'
  end

  # GET only
  # requires logged_in? and is_self?
  def edit
  end

  # POST only
  # requires logged_in? and is_self?
  def delete
    redirect_to :action => 'list'
  end

  # POST only
  # requires logged_in? and is_self?
  def update
    redirect_to :action => 'list'
  end

end
