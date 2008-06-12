module Location
  
  class Base < ActiveRecord::Base
    
    set_table_name 'locations'
    set_inheritance_column 'location_type'
    validates_presence_of :display_name
    validates_presence_of :location_type
    validates_inclusion_of :location_type, :in => ['Address', 'Airport'], :allow_blank => true
    
    # locations are immutable:
    attr_readonly :display_name, :location_type, :latitude, :longitude
    
    def lat; latitude; end
    def long; longitude; end
    def lng; longitude; end
    
    # Distance to +location+, in miles.  Subclasses *MUST* redefine this method.
    def distance_to(location)
      raise NotImplementedError.new('subclasses must redefine distance_to')
    end
    
    # Returns all addresses within +distance+ miles of this address.
    # If options[:include_self] is true, includes self.  Subclasses *MUST*
    # redefine this method.
    def find_within(distance = nil, options = {})
      raise NotImplementedError.new('subclasses must redefine find_within')
    end
    
    # Alias for +find_within+.
    def find_nearby(distance = nil, options = {}); find_within(distance, options); end
    
    # Whether +other+ is within +distance+ miles; +distance+ defaults to 
    # Location::DEFAULT_DISTANCE.  Subclasses *MUST* redefine this method.
    def near?(other, distance = nil)
      raise NotImplementedError.new('subclasses must redefine near?')
    end
    
    protected
    def display_name=(name)
      write_attribute :display_name, name
    end
    def location_type=(type)
      write_attribute :location_type, type
    end
    def latitude=(latitude)
      write_attribute :latitude, latitude
    end
    def longitude=(longitude)
      write_attribute :longitude, longitude
    end
    
  end
  
end