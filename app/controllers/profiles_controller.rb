class ProfilesController < ApplicationController
  
  requires_is_self :except => [ :show ]
  requires_profile
  
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
  def edit
  end

  # POST only
  def update
    requested_profile.update_attributes!(params[:profile] || {})
    current_user.profile.reload
    flash[:notice] = 'Your profile has been updated'
    redirect_to :action => 'show'
  end
  
  # GET or POST
  def refer_a_friend
    if request.get?
    elsif request.post?
      redirect_to :profile_id => current_user, :action => 'dashboard'
    end
  end
  
end
