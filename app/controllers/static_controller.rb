class StaticController < ApplicationController

  def welcome
  end
  
  def page
    render :action => params[:page]
  end
  
end
