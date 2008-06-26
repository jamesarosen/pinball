class FavoriteLocationsController < ApplicationController

  requires_is_self
  append_before_filter :require_favorite_location!, :only => [ :edit, :destroy, :update, :set_current ]
  
  # GET only
  def index
  end

  # GET only
  def new
  end
  
  # POST only
  def create
    @favorite_location = requested_profile.favorite_locations.build(favorite_location_params)
    @favorite_location.save!
    redirect_to :action => 'index'
  end

  # GET only
  def edit
  end

  # DELETE only
  def destroy
    requested_favorite_location.destroy
    requested_profile.favorite_locations(true)
    redirect_to :action => 'index'
  end

  # PUT only
  def update
    @favorite_location = requested_profile.favorite_locations.find_by_id(params[:favorite_location_id])
    @favorite_location.update_attributes!(favorite_location_params)
    @favorite_location.save!
    flash[:notice] = "Favorite location #{@favorite_location.name} updated"
    redirect_to :action => 'index'
  end
  
  def set_current
    requested_profile.location = requested_favorite_location
    requested_profile.save!
    current_user.reload
    redirect_to dashboard_path
  end
  
  private
  
  def favorite_location_params
    (params[:favorite_location] || {}).pass(:name, :location)
  end
  
  def requested_favorite_location(reload = false)
    safe_load :@favorite_location, Location::Favorite, :favorite_location_id, reload
  end
  
  def require_favorite_location!
    require_exists! requested_favorite_location, Location::Favorite, :favorite_location_id
  end

end
