require 'yaml'
require 'location/parser'
define_once :RAILS_CONFIG_ROOT, "#{RAILS_ROOT}/config"

['us', 'canadian', 'international'].each do |t|
  extra = YAML::load(File.open("#{RAILS_CONFIG_ROOT}/#{t}_airport_aliases.yml"))
  extra.each do |code, aliases|
    aliases.each do |a|
      existing_code = Location::Parser.airport_aliases[a]
      case existing_code
      when nil
        Location::Parser.airport_aliases[a] = code
      when code
        # do nothing
      else
        raise "Cannot define alias #{a} for #{code}; already defined for #{existing_code}" if existing_code
      end
    end
  end
end