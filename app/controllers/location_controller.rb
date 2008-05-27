class LocationController < ApplicationController

  requires_is_self :except => [ :current ]
  
  # GET only
  def current
  end
  
  # GET only
  def edit
  end

  # POST only
  def update
    new_location = params[:location]
    flash[:notice] = "Updated your location to #{new_location}"
    redirect_to :action => 'whos_around'
  end

  # GET only
  def whos_around
  end

end
