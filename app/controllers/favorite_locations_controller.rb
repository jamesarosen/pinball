class FavoriteLocationsController < ApplicationController

  requires_is_self
  
  # GET only
  def index
  end

  # GET only
  def new
  end
  
  # POST only
  def create
    redirect_to :action => 'index'
  end

  # GET only
  def edit
  end

  # DELETE only
  def destroy
    redirect_to :action => 'index'
  end

  # PUT only
  def update
    redirect_to :action => 'index'
  end

end
