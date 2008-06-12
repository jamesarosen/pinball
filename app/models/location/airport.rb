module Location
  
  class Airport < Location::Base
    
    validates_uniqueness_of :display_name, :on => :create, :allow_blank => true
    validate_on_create :validate_no_lat_long
    
    def ==(other)
      other.kind_of?(Airport) && other.display_name == self.display_name
    end

    def distance_to(location)
      location == self ? 0.0 : Location::NOWHERE_NEAR
    end
    
    def find_within(distance = nil, options = {})
      options[:include_self] == true ? [self] : []
    end
    
    def near?(location, distance = nil)
      self == location
    end
    
    private
    
    def validate_no_lat_long
      errors.add_to_base('Airport addresses should not have a latitude or longitude') unless lat.blank? && long.blank?
    end
    
  end
  
end