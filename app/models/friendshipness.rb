# A mixin providing the methods for friendshipness.
# Mixing-in class +must+ provide a +profile+ method that
# returns a Profile.  (User and Profile both do.)
module Friendshipness
  
  module ByTier
    def by_tier(tier)
      find(:all, :conditions => ["friendships.tier = ?", tier])
    end
  end
  
  # Friend Methods
  
  def friendships(force_reload = false)
    @friendships = nil if force_reload
    @friendships ||= profile.follower_friends(force_reload).mutual
  end
  
  def friends(force_reload = false)
    @friends = nil if force_reload
    @friends ||= friendships(force_reload).map { |f| f.followee }
  end
  
  def friends_with?(user_or_profile)
    profile.friends.include?(user_or_profile.profile)
  end
  
  def followed_by?(user_or_profile)
    profile.followers.include?(user_or_profile.profile)
  end
  
  def following?(user_or_profile)
    profile.followees.include?(user_or_profile.profile)
  end
  
  def follow!(user_or_profile, tier = 3)
    f = Friendship.new(:follower => self.profile, :followee => user_or_profile.profile, :tier => tier)
    f.save!
    profile.follower_friends(true)
    f
  end
  
  def unfollow!(user_or_profile)
    find_following!(user_or_profile) do |f|
      f.destroy
    end  
    profile.follower_friends(true)
    nil
  end
  
  def move_to_tier!(user_or_profile, new_tier)
    f = find_following!(user_or_profile) do |f|
      if f.tier == new_tier
        errors.add(:base, "#{user_or_profile} is already in tier #{new_tier}")
        raise ActiveRecord::RecordInvalid.new(self)
      else
        f.tier = new_tier
        f.save!
        f
      end 
    end
    profile.follower_friends(true)
    f
  end
  
  private
  
  def find_following!(user_or_profile, &block)
    result = nil
    transaction do
      Friendship.find_friendship!(self, user_or_profile.profile) do |f|
        result = block.call(f)
      end
    end
    result
  end
  
end