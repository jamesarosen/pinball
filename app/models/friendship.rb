class Friendship < ActiveRecord::Base
  
  TIER_1 = 1
  TIER_2 = 2
  TIER_3 = 3
  
  class <<self
  
    # Finds a friendship and yields it (or nil), returning the value
    # returned by the block.
    # +block+ defaults to { |f| f }
    def find_friendship(follower, followee, tier = nil, &block) # :yields: following
      find_friendship_helper(follower, followee, tier, false, &block)
    end
  
    # Same as find_following, but raises ActiveRecord::RecordNotFound error
    # before calling the block if no matching record is found.
    def find_friendship!(follower, followee, tier = nil, &block) # :yields: following
      find_friendship_helper(follower, followee, tier, true, &block)
    end
    
    private
    def find_friendship_helper(follower, followee, tier, strict, &block)
      f = if follower && followee
        conditions = {:follower_id => follower, :followee_id => followee}
        conditions.merge(:tier => tier) if tier
        find(:first, :conditions => conditions)
      else
        nil
      end
      raise ActiveRecord::RecordNotFound.new("#{follower} is not following #{followee}") if strict && f.nil?
      block ? block.call(f) : f
    end
    
  end
  
  named_scope :by_tier, lambda { |tier| { :conditions => { :tier => tier } } }
  named_scope :mutual,  :select => 'friendships.*',
                        :joins => 'INNER JOIN friendships F2 ON F2.follower_id = friendships.followee_id',
                        :conditions => 'friendships.follower_id = F2.followee_id',
                        :readonly => true
  
  belongs_to :follower, :class_name => 'Profile'
  belongs_to :followee, :class_name => 'Profile'
  
  validate :validate_follower_and_followee_differ
  validates_presence_of :follower, :followee, :tier
  validates_inclusion_of :tier, :in => [TIER_1, TIER_2, TIER_3], :allow_blank => true, :message => 'is invalid'
  validate :validate_not_already_following
  
  def mutual?
    Friendship.count(:conditions => {:follower_id => followee, :followee_id => follower}) > 0
  end
  
  private
  
  def validate_follower_and_followee_differ
    if followee && follower && followee.profile == follower.profile
      errors.add(:follower, 'follower and followee can not be the same person')
    end
  end
  
  def validate_not_already_following
    self.class.find_friendship(follower, followee) do |f|
      errors.add(:followee, "is already following #{followee}") unless f.nil? || f == self
    end
  end
  
end