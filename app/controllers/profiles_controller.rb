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
    update_profile(params[:profile])
    update_password(params[:old_password], params[:new_password], params[:new_password_confirmation])
    redirect_to :action => 'show'
  end
  
  # GET or POST
  def refer_a_friend
    if request.get?
    elsif request.post?
      redirect_to :profile_id => current_user, :action => 'dashboard'
    end
  end
  
  private
  
  def update_profile(profile_hash)
    if profile_hash && !profile_hash.empty?
      requested_profile.update_attributes!(profile_hash)
      current_user.profile.reload # current_user.profile is a different reference to the same object (unless admin?)
      flash[:notice] = 'Your profile has been updated'
    end
  end
  
  def update_password(op, np, npc)
    if op || np || npc
      requested_profile.user.change_password!(op, np, npc)
      flash['notice 2'] = 'Your password has been changed'
    end
  end
  
end
