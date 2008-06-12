class SettingsController < ApplicationController

  requires_is_self
  
  # GET only
  def edit_notifications
    render :action => 'notifications'
  end
  
  # POST only
  def update_notifications
    render :action => 'privacy'
  end

  # GET only
  def edit_privacy
    render :action => 'privacy'
  end
  
  # POST only
  def update_privacy
    render :action => 'privacy'
  end

end
