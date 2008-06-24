module SettingsHelper
  
  PRETTY_VERSIONS = [
    ['Everyone',      HasPrivacy::Authorization::EVERYONE],
    ['Logged-In',     HasPrivacy::Authorization::LOGGED_IN],
    ['Followees',     HasPrivacy::Authorization::FOLLOWEES],
    ['Tier 1',        HasPrivacy::Authorization::TIER_1_FOLLOWEES],
    ['Tiers 1 and 2', HasPrivacy::Authorization::TIERS_1_2_FOLLOWEES],
    ['Just Me',       HasPrivacy::Authorization::SELF]
  ]
  
  def select_setting_tag(setting_name, options = {}, &block)
    allowed_values  = PRETTY_VERSIONS.select do |x|
      Setting::ALLOWED_SETTINGS[setting_name].include?(x[1])
    end
    selected_value = requested_profile.get_setting(setting_name)
    puts "Property: #{setting_name}\nallowed values: #{allowed_values.inspect}\nselected value: #{selected_value}"
    option_tags = options_for_select(allowed_values, selected_value)
    
    concat('<div>')
    concat(capture(&block))
    concat(select_tag_without_before_and_after(setting_name, option_tags))
    concat('</div>')
  end
  
end
