class Profile < ActiveRecord::Base
  include Tidbits::ActiveRecord::ValidatesEmail
  include CellPhone
  include Location::Locatable
  include Friendshipness
  include HasSettings
  include HasPrivacy
  
  belongs_to :user
  
  validates_presence_of :email
  validates_email :message => 'is not a valid email address', :allow_blank => true
  validates_length_of :email, :within => 3..100, :allow_blank => true#, :message => 'is not a valid email address'
  validates_uniqueness_of :email, :case_sensitive => false, :allow_blank => true
  
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