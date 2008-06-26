module Location
  
  class Address < Location::Base
    
    acts_as_mappable  :lat_column_name => :latitude,
                      :lng_column_name => :longitude
    
    define_once :VALID_LATITUDES, (-90..90)
    define_once :VALID_LONGITUDES, (-180..180)
    
    def self.distance_between_with_class_check(a, b, options = {})
      return NOWHERE_NEAR unless a.kind_of?(Location::Address) && b.kind_of?(Location::Address)
      distance_between_without_class_check(a, b, options)
    end
    
    # as long as we're using sqlite3, we have to hack this:
    def self.find_within(distance = nil, options = {})
      distance ||= Location::DEFAULT_DISTANCE
      origin = extract_origin_from_options(options)
      result = find_within_bounds(GeoKit::Bounds.from_point_and_radius(origin, distance), options)
      result.sort_by_distance_from origin
    end
    
    # as long as we're using sqlite3, we have to hack this:
    def self.count_within(distance = nil, options = {})
      distance ||= Location::DEFAULT_DISTANCE
      origin = extract_origin_from_options(options)
      count_within_bounds(GeoKit::Bounds.from_point_and_radius(origin, distance), options)
    end
    
    class <<self
      alias_method_chain :distance_between, :class_check
      
      # hide sqlite3-incompatible methods
      private :find_beyond, :find_by_range, :find_closest, :find_farthest, :count_beyond, :count_by_range
    end
    
    before_validation :geocode_address_if_necessary
    validate_on_create :validate_has_lat_long
    
    def find_within(options = {})
      include_self = (options.delete(:include_self) != false)
      distance = options.delete(:distance) || Location::DEFAULT_DISTANCE
      result = self.class.find_within(distance, options.merge(:origin => self))
      result.delete(self) unless include_self
      result
    end
    
    def near?(other, distance = nil)
      distance_to(other) < (distance || Location::DEFAULT_DISTANCE)
    end
    
    private
    
    def geocode_address_if_necessary
      if !address.blank? && (lat.blank? || long.blank?)
        geo = GeoKit::Geocoders::MultiGeocoder.geocode(address)
        if geo.success
          self.latitude = geo.lat
          self.longitude = geo.lng
        end
        geo.success
      else
        true
      end
    end
    
    def validate_has_lat_long
      if lat.blank? || long.blank?
        errors.add_to_base("Could not find address #{address}")
      elsif !VALID_LATITUDES.include?(lat) || !VALID_LONGITUDES.include?(long)
        errors.add_to_base("Error geocoding #{address}; received (#{lat}, #{long})")
      end
    end
    
  end
  
end