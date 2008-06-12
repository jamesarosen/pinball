module Location
  module Locatable
    
    def self.included(base)
      base.belongs_to :location,
                      :class_name => "Location::Base"
                
      base.validate :validate_location_is_parseable
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
      when Locatable
        self.location.near?(other.location, distance)
      when Location
        self.location.near?(other, distance)
      else
        raise ArgumentError.new("#{other} is neither a Location nor a Locatable")
      end
    end
    
    def location=(location)
      case location
      when nil, ''
        self.location_id = nil
      when Location::Base
        self.location_id = location.id
      when String
        begin
          self.location_id = Location::parse(location).id
        rescue Location::ParseError
          @unparseable_location = location
        end
      end
    end
    
    private
    
    def validate_location_is_parseable
      if @unparseable_location
        errors.add(:location, 'could not be found')
        @unparseable_location = nil
      end
    end
    
  end
end