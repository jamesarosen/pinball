class LocationController < ApplicationController

  requires_profile :only => [ :current ]
  requires_is_self :except => [ :current ]
  
  # GET only
  def current
    @location = requested_profile.location || 'Nowhere'
  end
  
  # GET only
  def edit
    @location = requested_profile.location
  end

  # POST only
  def update
    requested_profile.location = params[:location]
    requested_profile.save!
    current_user.reload
    flash[:notice] = "Updated your location to #{requested_profile.location}"
    if requested_profile.location
      redirect_to :action => 'whos_around'
    else
      redirect_to :controller => 'profiles', :action => 'dashboard', :profile_id => current_user
    end
  end

  # GET only
  def whos_around
    if requested_profile.location.nil?
      flash[:notice] = "Please set your current location to see who's around"
      redirect_to :action => 'edit'
    else
      @whos_around = requested_profile.find_nearby(:include_self => false)
    end
  end

end
