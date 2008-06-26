module Location
  
  # The default radius for searches
  define_once :DEFAULT_DISTANCE, 50
  
  # A distance representing that locations are nowhere near one another.
  define_once :NOWHERE_NEAR, Float::MAX
  
  # Creates a new Location::Parser and calls parse on it.
  def self.parse(value, favorites = [])
    Location::Parser.new.parse(value, favorites)
  end
  
end
    