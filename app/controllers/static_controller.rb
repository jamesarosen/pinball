class StaticController < ApplicationController
  
  def index
  end

  def welcome
    if logged_in?
      redirect_to dashboard_url(:profile_id => current_user)
    end
  end
  
  def page
    render :action => params[:page]
  end
  
end
