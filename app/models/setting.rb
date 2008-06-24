class Setting < ActiveRecord::Base
  
  allowed_privacy_values = HasPrivacy::Authorization::AUTHORIZATIONS.map { |a| a.to_param }
  
  PRIVACY_SEARCH_RESULT   = 'privacy.search_result'
  PRIVACY_VIEW_PROFILE    = 'privacy.profile.view'
  PRIVACY_VIEW_EMAIL      = 'privacy.profile.email.view'
  PRIVACY_VIEW_CELL_PHONE = 'privacy.profile.cell_phone.view'
  PRIVACY_VIEW_FOLLOWEES  = 'privacy.profile.followees.view'
  
  PRIVACY_SETTINGS = {
    PRIVACY_SEARCH_RESULT   => allowed_privacy_values,
    PRIVACY_VIEW_PROFILE    => allowed_privacy_values,
    PRIVACY_VIEW_EMAIL      => allowed_privacy_values,
    PRIVACY_VIEW_CELL_PHONE => allowed_privacy_values,
    PRIVACY_VIEW_FOLLOWEES  => allowed_privacy_values
  }
  
  ALLOWED_SETTINGS = PRIVACY_SETTINGS
  
  DEFAULT_SETTINGS = {
    PRIVACY_SEARCH_RESULT   => HasPrivacy::Authorization::EVERYONE,
    PRIVACY_VIEW_PROFILE    => HasPrivacy::Authorization::LOGGED_IN,
    PRIVACY_VIEW_EMAIL      => HasPrivacy::Authorization::FOLLOWEES,
    PRIVACY_VIEW_CELL_PHONE => HasPrivacy::Authorization::FOLLOWEES,
    PRIVACY_VIEW_FOLLOWEES  => HasPrivacy::Authorization::LOGGED_IN
  }
  
  def self.valid_setting_name?(name)
    !!ALLOWED_SETTINGS[name]
  end
  
  def self.valid_setting_value?(name, value)
    valid_setting_name?(name) && ALLOWED_SETTINGS[name].include?(value)
  end
  
  belongs_to :profile
  
  validates_presence_of :profile
  validates_presence_of :name, :value
  validate :validate_name
  validates_uniqueness_of :name, :allow_blank => true, :scope => :profile_id
  validate :validate_value
  
  private
  
  def validate_name
    unless name.blank?
      errors.add(:name, "is not a valid setting name") unless self.class.valid_setting_name?(name)
    end
  end
  
  def validate_value
    unless name.blank? || value.blank?
      errors.add(:value, "is not a valid value for setting #{name}") unless self.class.valid_setting_value?(name, value)
    end
  end
  
end