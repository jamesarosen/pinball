class Profile < ActiveRecord::Base
  include CellPhone
  include Location::Locatable
  
  belongs_to :user
  
  # Friends
  has_many :friendships, :foreign_key => 'inviter_id', :conditions => "status = #{Friend::ACCEPTED}"
  has_many :follower_friends, :foreign_key => "invited_id", :conditions => "status = #{Friend::PENDING}"
  has_many :following_friends, :foreign_key => "inviter_id", :conditions => "status = #{Friend::PENDING}"
  
  has_many :friends,   :through => :friendships, :source => :invited
  has_many :followers, :through => :follower_friends, :source => :inviter
  has_many :followings, :through => :following_friends, :source => :invited
  
  validates_presence_of :email
  validates_email :message => 'is not a valid email address', :allow_blank => true
  validates_length_of :email, :within => 3..100, :allow_blank => true#, :message => 'is not a valid email address'
  validates_uniqueness_of :email, :case_sensitive => false, :allow_blank => true
  
  # Friend Methods
  def friend_of?(user_or_profile)
    user_or_profile.profile.in?(friends)
  end
  
  def followed_by?(user_or_profile)
    user_or_profile.profile.in?(followers)
  end
  
  def following?(user_or_profile)
    user_or_profile.profile.in?(followings)
  end
  
  def to_s
    return display_name unless display_name.blank?
    return user.login unless user.blank?
    'Deleted User'
  end
  
  def to_param
    "#{self.id}-#{to_s.to_safe_uri}"
  end
  
  def profile
    self
  end
  
end