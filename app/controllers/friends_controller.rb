class FriendsController < ApplicationController

  requires_is_self :only => [ :following_by_tier, :follow, :unfollow, :move_to_tier ]
  
  attr_reader :requested_tier
  helper_method :requested_tier
  
  # GET only
  def followers
  end

  # GET only
  # all followings
  def following
  end
  
  # GET only
  # followings in tier params[:tier]
  def following_by_tier
    @requested_tier = params[:tier]
  end

  # GET only: intersection of followers and following
  def friends
  end

  # POST only: add a following
  def follow
    redirect_to :action => 'following'
  end
  
  # POST only: delete a following
  def unfollow
    redirect_to :action => 'following'
  end
  
  # POST only: moves a following to a different tier
  def move_to_tier
    redirect_to :action => 'following_by_tier', :tier => params[:tier]
  end
  
end
