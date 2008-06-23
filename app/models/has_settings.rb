# mixin for settings
module HasSettings
  
  def self.included(base)
    base.has_many :settings
  end
  
  # Get the value of the setting named +name+, returning the default
  # if +self+ has none set.
  def get_setting(name)
    raise ArgumentError.new("#{name} is not a valid setting name") unless Setting.valid_setting_name?(name)
    find_setting(name) do |s|
      s.nil? ? Setting::DEFAULT_SETTINGS[name] : s.value
    end
  end
  
  # Create or update a setting.
  def set_setting(name, value)
    find_setting(name) do |s|
      if s.nil?
        self.settings.create!(:name => name, :value => value)
      else
        s.value = value
        s.save!
      end
    end
  end

  # Find the Setting object for +self+ with name +name+.
  def find_setting(name, &block) # :yields: s
    s = Setting.find(:first, :conditions => { :profile_id => self, :name => name })
    if block_given?
      yield s
    else
      s
    end
  end
  
end