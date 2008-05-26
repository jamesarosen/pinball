class FriendsController < ApplicationController
  include ModelLoader
  
  before_filter :load_profile
  
  # GET only
  def followers
  end

  # GET only
  def following
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
  
end
