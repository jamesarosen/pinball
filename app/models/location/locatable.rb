require 'location'

# Mixin to be included by anything that belongs_to :location
module Location::Locatable
  
  def self.included(base)
    base.send :include, Location::Locatable::InstanceMethods
    base.belongs_to :location,
                    :class_name => "Location::Base"
    base.validate :validate_location_is_parseable
    base.after_save :clear_unparseable_location
    base.alias_method_chain_once :location, :unparseable
    base.alias_method_chain_once :location=, :parse
    base.alias_method_chain_once :update_attributes, :parse_location
    base.alias_method_chain_once :update_attributes!, :parse_location
    base.alias_method_chain_once :initialize, :parse_location
  end
  
  module InstanceMethods
    
    def initialize_with_parse_location(options = nil)
      options ||= {}
      initialize_without_parse_location(options.block(:location))
      self.location = options[:location]
    end
  
    # Returns all instance of <tt>self.class</tt> within
    # +<tt>options[:distance]</tt> (defaults to Location::DEFAULT_DISTANCE)
    # miles of +location+.
    #
    # If options[:include_self] is true (by default it is), includes self.
    #
    # Returns [] if +location+ is +nil+.
    def find_within(options = {})
      return [] if self.location.nil?
      include_self = (options.delete(:include_self) != false)
    
      # want location to include itself regardless:
      locations = self.location.find_within(options.merge(:include_self => true))
    
      result = self.class.find(:all, :conditions => { :location_id => locations.map(&:id) })
      result.delete(self) unless include_self
      result
    end
  
    # Alias for +find_within+.
    def find_nearby(options = {}); find_within(options); end
  
    # Whether +other+ is within +distance+ miles.  +distance+ defaults to 
    # Location::DEFAULT_DISTANCE.  +other+ can be a Location::Base or a
    # Locatable.
    #
    # Returns false if +location+ is +nil+.
    def near?(other, distance = nil)
      return false if self.location.nil?
      case other
      when Location::Locatable
        self.location.near?(other.location, distance)
      when Location::Base
        self.location.near?(other, distance)
      else
        raise ArgumentError.new("#{other} is neither a Location nor a Locatable")
      end
    end
    
    def location_with_unparseable
      @unparseable_location || location_without_unparseable
    end
  
    def location_with_parse=(location)
      begin
        favorites = respond_to?(:favorite_locations) ? favorite_locations : []
        self.location_without_parse = Location::parse(location, favorites)
      rescue Location::ParseError
        @unparseable_location = location
      end
    end
    
    def update_attributes_with_parse_location(attributes = {})
      self.location = attributes[:location] if attributes[:location]
      update_attributes_without_parse_location(attributes.block(:location))
    end
    
    def update_attributes_with_parse_location!(attributes = {})
      self.location = attributes[:location] if attributes[:location]
      update_attributes_without_parse_location!(attributes.block(:location))
    end
  
    private
  
    def validate_location_is_parseable
      if @unparseable_location
        errors.add(:location, 'could not be found')
      end
    end
    
    def clear_unparseable_location
      @unparseable_location = nil
    end
  
  end
end