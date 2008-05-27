class FavoriteLocationsController < ApplicationController

  requires_is_self
  
  # GET only
  def list
  end

  # GET only
  def add
  end
  
  # POST only
  def create
    redirect_to :action => 'list'
  end

  # GET only
  def edit
  end

  # POST only
  def delete
    redirect_to :action => 'list'
  end

  # POST only
  def update
    redirect_to :action => 'list'
  end

end
