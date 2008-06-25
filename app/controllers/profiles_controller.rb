class ProfilesController < ApplicationController
  
  requires_profile
  requires_authorization(Setting::PRIVACY_VIEW_PROFILE, :only => [ :show ])
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
  def edit
  end

  # POST only
  def update
    update_profile(params[:profile])
    update_password(params[:old_password], params[:new_password], params[:new_password_confirmation])
    redirect_to :action => 'show'
  end
  
  # GET only
  def refer_a_friend_form
    render :action => 'refer_a_friend'
  end
  
  # POST only
  def refer_a_friend
    redirect_to :profile_id => current_user, :action => 'dashboard'
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
