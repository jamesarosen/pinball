class ProfilesController < ApplicationController
  
  requires_is_self :except => [ :show ]
  
  # GET only
  def dashboard
  end
  
  # GET only
  def getting_started
  end

  # GET only
  def show
  end

  # GET only
  # requires logged_in? and is_self?
  def edit
  end

  # POST only
  # requires logged_in? and is_self?
  def update
    redirect_to :action => 'show'
  end
  
  # GET or POST
  # requires logged_in? and is_self?
  def refer_a_friend
    if request.get?
    elsif request.post?
      redirect_to :profile_id => current_user, :action => 'dashboard'
    end
  end
  
end
