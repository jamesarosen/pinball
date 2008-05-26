class FriendsController < ApplicationController
  include ModelLoader
  
  before_filter :load_profile
  
  # GET only
  def followers
  end

  # GET only
  # all followings
  def following
  end
  
  # GET only
  # followings in tier params[:tier]
  # requires logged_in? and is_self?
  def following_by_tier
    @tier = params[:tier]
  end

  # GET only: intersection of followers and following
  def friends
  end

  # POST only: add a following
  # requires logged_in? and is_self?
  def follow
    redirect_to :action => 'following'
  end
  
  # POST only: delete a following
  # requires logged_in? and is_self?
  def unfollow
    redirect_to :action => 'following'
  end
  
  # POST only: moves a following to a different tier
  # requires logged_in? and is_self?
  def move_to_tier
    redirect_to :action => 'following_by_tier'
  end
  
end
