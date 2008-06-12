module Location
  module Locatable
    
    def self.included(base)
      base.belongs_to :location,
                      :class_name => "Location::Base"
                
      base.validate :validate_location_is_parseable
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