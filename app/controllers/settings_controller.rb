class SettingsController < ApplicationController

  include ModelLoader

  before_filter :load_logged_in_profile
  before_filter :load_requested_profile
  
  # GET or POST
  # requires logged_in? and is_self?
  def notifications
  end

  # GET or POST
  # requires logged_in? and is_self?
  def privacy
  end

end
