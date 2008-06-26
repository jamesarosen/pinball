module Location
  class Favorite < ActiveRecord::Base
    
    include Location::Locatable
    
    set_table_name 'favorite_locations'
    
    belongs_to :profile
  
    validates_presence_of :name
    validates_length_of :name, :within => 1..20, :allow_blank => true
    validates_uniqueness_of :name, :allow_blank => true, :scope => :profile_id, :message => 'is already a favorite of yours'
    validates_presence_of :location_id, :profile_id
  
    def ===(other)
      case other
      when Location::Favorite
        self == other
      when Location::Base
        self.location == other
      when String
        self.name == other
      else
        false
      end
    end
  
    def ==(other)
      other.kind_of?(Location::Favorite) && self.name == other.name && self.location == other.location
    end
  
    def to_s
      "#{name}: #{location}"
    end
  
  end
end