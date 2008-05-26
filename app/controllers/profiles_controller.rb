class ProfilesController < ApplicationController
  
  before_filter :load_profile

  # GET only
  def show
  end

  # GET only
  def edit
  end

  # POST only
  def update
    redirect_to :action => 'show'
  end
  
  private
  
  def load_profile
    @profile = params[:profile_id]
  end
  
end
