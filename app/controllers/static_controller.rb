class StaticController < ApplicationController
  
  def index
    delete_sidebar_widget :help
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
