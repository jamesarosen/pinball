require 'digest/sha1'

class User < ActiveRecord::Base
  include Friendshipness
  
  def self.authenticate(login, password)
    u = find_by_login(login) # need to get the salt
    u && u.is_current_password?(password) ? u : nil
  end
  
  def self.encrypt(a, b)
    Digest::SHA1.hexdigest("--#{a}--#{b}--")
  end
  
  
  
  # has one Profile
  # If the User is deleted, keep the Profile,
  # but delete the foreign key back to the User
  # and deactivate the profile.
  has_one :profile, :dependent => :nullify
  
  validates_each(:email, :on => :create, :allow_blank => true) do |user, attribute, value|
    p = Profile.find_by_email(value)
    user.errors.add(attribute, 'is already taken') unless p.blank?
  end
  after_create do |user|
    p = Profile.find_or_create_by_email(user.email)
    raise ActiveRecord::ConflictedRecordError.new(user, 'User found when should be nil') unless p.user.blank?
    p.user = user
    p.save
  end
  
  
  
  # virtual (not persisted) fields for use on creation
  # and changing password
  attr_accessor :password, :password_confirmation, :email, :terms_of_service
  
  attr_protected :is_admin
  
  validates_presence_of :login
  validates_length_of :login, :within => 3..40, :unless => Proc.new { |u| u.login.blank? }
  validates_uniqueness_of :login, :case_sensitive => false, :allow_blank => true
  
  validates_acceptance_of :terms_of_service, :on => :create
  
  validates_presence_of :password, :if => :password_required?
  validates_length_of :password, :within => 4..40, :if => :password_required?, :allow_blank => true
  validates_presence_of :password_confirmation, :if => :password_required?, :allow_blank => true
  validates_confirmation_of :password, :if => :password_required?, :allow_blank => true
  
  validates_presence_of :email, :on => :create
  validates_email :on => :create, :allow_blank => true, :message => 'is not a valid email address'
  
  before_save :encrypt_password!
  
public
  
  def is_current_password?(pw)
    crypted_password == encrypt(pw)
  end
  
  def change_password(old_password, new_password, confirm_password)
    if change_password_helper(old_password, new_password, confirm_password, false)
      save
    else
      false
    end
  end
  
  def change_password!(old_password, new_password, confirm_password)
    change_password_helper(old_password, new_password, confirm_password, true)
    save!
  end
  
  def forgot_password!
    @forgot_password = true
    new_password = self.password = self.password_confirmation = new_random_password
    encrypt_password!
    save!
    new_password
  end
  
  def forgot_password?
    !!(@forgot_password)
  end
  
  def remember_me!
    self.remember_token_expires_at = 10.years.from_now
    self.remember_token ||= encrypt(remember_token_expires_at)
    save false
  end
  
  def remember_token?
    remember_token_expires_at? && Time.now.utc < remember_token_expires_at 
  end
  
  def to_s
    profile.to_s
  end

private

  def encrypt(x)
    self.class.encrypt(self.salt, x)
  end
  
  def generate_salt!
    self.salt = self.class.encrypt(Time.now, login)
  end
  
  def encrypt_password!
    return if password.nil?
    generate_salt! if new_record? || forgot_password?
    self.crypted_password = encrypt(password)
    self.password = password_confirmation = nil
  end
  
  def password_required?
    crypted_password.blank? || !password.blank?
  end
  
  def new_random_password
    encrypt(Time.now)[0,12]
  end
  
  
  def change_password_helper(old_password, new_password, confirm_password, strict)
    errors.add( :password, 'The password you supplied is not the correct password.') unless is_current_password?(old_password)
    errors.add( :password, 'The new password and old password are identical') if old_password == new_password
    errors.add( :password, 'The new password does not match the confirmation password.') unless new_password == confirm_password
    errors.add( :password, 'The new password may not be blank.') if new_password.blank?
    
    unless errors.empty?
      raise ActiveRecord::RecordInvalid.new(self) if strict
      return false
    end
    
    self.password = self.password_confirmation = new_password
    encrypt_password!
    true
  end
  
  
end
