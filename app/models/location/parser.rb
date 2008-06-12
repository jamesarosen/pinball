module Location #:nodoc:

  class ParseError < StandardError
    attr_accessor :value
    def initialize(value)
      super("Could not parse #{value} as a location.")
      @value = value
    end
  end
  
  # Parses Strings into Locations
  class Parser
    
    @@airport_aliases = {}
    cattr_reader :airport_aliases
    
    # Parses +value+ into a Location or raises an error.
    # If +value+ is already a Location::Base, returns it.
    # Tries to parse +value+ as a Location::Airport first,
    # then tries geocoding it to a Location::Address.
    # If a value is returned, the value is guaranteed to
    # have been saved to the database.
    def parse(value)
      return value if value.kind_of?(Location::Base)
      return nil if value.blank?
      
      airport = parse_airport(value)
      return airport if airport
      
      address = parse_address(value)
      return address if address
      
      raise ParseError.new(value)
    end
    
    private
    
    def parse_airport(value)
      code = parse_airport_code(value)
      code.nil? ? nil : Location::Airport.find_or_create_by_display_name(code)
    end
    
    AIRPORT_ALIAS_REGEX = /municipal|regional|international|airport/
    AIRPORT_CODE_REGEX = /^[[:alpha:]]{3}$/
    PUNCTUATION = /[^[:alnum:]]/
    
    def parse_airport_code(value)
      value = value.strip
      case value
      when AIRPORT_CODE_REGEX
        value.upcase!
        airport_aliases.values.include?(value) ? value : nil
      when AIRPORT_ALIAS_REGEX
        value.downcase!
        airport_name = value.gsub(AIRPORT_ALIAS_REGEX, '').gsub(PUNCTUATION, '').strip
        self.class.airport_aliases[airport_name]
      else
        nil
      end
    end
    
    def parse_address(value)
      existing_address = Location::Address.find_by_display_name(value)
      return existing_address if existing_address
      
      new_address = Location::Address.new(:display_name => value)
      return new_address if new_address.save
      
      return nil
    end
    
    cattr_accessor :airport_aliases
    
  end
  
end