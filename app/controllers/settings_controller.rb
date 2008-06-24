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
    if params[:commit] =~ /update/i
      update_settings(Setting::PRIVACY_SETTINGS.keys)
      flash[:notice] = 'Your privacy settings have been updated.'
      render :action => 'privacy'
    else    
      flash[:notice] = "Your privacy settings have not been changed."
      redirect_to dashboard_path
    end
  end
  
  private
  
  def handle_invalid_record(exception)
    @exception = exception
    case params[:action]
    when /privacy/
      render :action => 'privacy', :status => 400
    when /notification/
      render :action => 'notifications', :status => 400
    end
  end
  
  def update_settings(setting_names)
    flash[:notice] = ''
    setting_names.each do |name|
      before = requested_profile.get_setting(name)
      after = params[name]
      unless before == after || after.blank?
        requested_profile.set_setting(name, after)
      end
    end
  end

end
