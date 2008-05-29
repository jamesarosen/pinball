class Profile < ActiveRecord::Base

  def self.parse_cell_number(number)
    number = (number.to_s || '').gsub(/[^[:digit:]]/, '')
    number.blank? ? nil : number.to_i
  end

  def self.cell_phone_carriers
    ['AT&T', 'Cingular', 'T-Mobile', 'Verizon']
  end
  
  belongs_to :user
  
  validates_presence_of :email
  validates_email :message => 'is not a valid email address', :allow_blank => true
  validates_length_of :email, :within => 3..100, :allow_blank => true#, :message => 'is not a valid email address'
  validates_uniqueness_of :email, :case_sensitive => false, :allow_blank => true
  validates_numericality_of :cell_number, :allow_blank => true
  validates_inclusion_of :cell_carrier, :in => Profile.cell_phone_carriers, :allow_blank => true, :message => 'is not a valid cellular provider'  
  
  before_save do |profile|
    profile.cell_number = Profile.parse_cell_number(profile.cell_number)
  end
  
  def to_s
    return display_name unless display_name.blank?
    return user.login unless user.blank?
    'Deleted User'
  end
  
  def to_param
    "#{self.id}-#{to_s.to_safe_uri}"
  end
  
end