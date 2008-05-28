require 'digest/sha1'

class User < ActiveRecord::Base
  
  # virtual (not persisted) fields for use on creation
  # and changing password
  attr_accessor :password, :password_confirmation, :email, :terms_of_service
  
  attr_protected :is_admin
  
  validates_presence_of :login
  validates_length_of :login, :within => 3..40
  validates_uniqueness_of :login, :case_sensitive => false
  
  validates_acceptance_of :terms_of_service, :on => :create
  
  validates_presence_of :password, :if => :password_required?
  validates_length_of :password, :within => 4..40, :if => :password_required?
  validates_presence_of :password_confirmation, :if => :password_required?
  validates_confirmation_of :password, :if => :password_required?
  
  validates_presence_of :email, :on => :create
  validates_email :on => :create
  
  before_save :encrypt_password!
  
public
  def self.authenticate(login, password)
    u = find_by_login(login) # need to get the salt
    u && u.is_current_password?(password) ? u : nil
  end
  
  def self.encrypt(a, b)
    Digest::SHA1.hexdigest("--#{a}--#{b}--")
  end
  
  def profile; self; end
  
  def is_current_password?(pw)
    crypted_password == encrypt(pw)
  end
  
  def change_password(old_password, new_password, confirm_password)
    errors.add( :password, 'The password you supplied is not the correct password.') and
      return false unless is_current_password?(old_password)
    errors.add( :password, 'The new password and old password are identical') and
      return false if old_password == new_password
    errors.add( :password, 'The new password does not match the confirmation password.') and
      return false unless new_password == confirm_password
    errors.add( :password, 'The new password may not be blank.') and
      return false if new_password.blank?
    
    self.password = self.password_confirmation = new_password
    encrypt_password!
    save
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
  
  
end
