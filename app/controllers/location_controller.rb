class LocationController < ApplicationController
  include ModelLoader

  before_filter :load_logged_in_profile
  before_filter :load_requested_profile, :only => [ :current, :edit, :update ]
  
  # GET only
  def current
  end
  
  # GET only
  # requires logged_in? and is_self?
  def edit
  end

  # POST only
  # requires logged_in? and is_self?
  def update
    @new_location = params[:location]
    flash[:notice] = "Updated your location to #{@new_location}"
    redirect_to :action => 'whos_around'
  end

  # GET only
  # requires logged_in?
  def whos_around
  end

end
