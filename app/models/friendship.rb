class Friendship < ActiveRecord::Base
  named_scope :by_tier, lambda { |tier| { :conditions => { :tier => tier } } }
  
  belongs_to :inviter, :class_name => 'Profile'
  belongs_to :invitee, :class_name => 'Profile'
  
  ACCEPTED = 1
  PENDING = 0
  
  TIER_1 = 1
  TIER_2 = 2
  TIER_3 = 3
  
  validate :validate_inviter_and_invitee_differ
  validates_presence_of :inviter, :invitee, :status, :tier
  validates_inclusion_of :status, :in => [ACCEPTED, PENDING], :allow_blank => true
  validates_inclusion_of :tier, :in => [TIER_1, TIER_2, TIER_3], :allow_blank => true
  
  
end