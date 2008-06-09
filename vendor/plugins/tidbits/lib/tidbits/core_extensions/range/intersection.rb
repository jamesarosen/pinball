module Tidbits #:nodoc: 
  module CoreExtensions #:nodoc: 
    module Range #:nodoc: 
      # Generate the intersection of two Ranges
      module Intersection 
        def &(other) 
          if self.empty? 
            self.dup 
          elsif other.empty? 
            other.dup 
          elsif self == other 
            self.dup 
          elsif self.include?(other) 
            other.dup 
          elsif other.include?(self) 
            self.dup 
          elsif other.first <= self.last && other.include?(self.last) 
            return ::Range.new(other.first, self.last, self.exclude_end?) 
          elsif self.first <= other.last && self.include?(other.last) 
            return ::Range.new(self.first, other.last, other.exclude_end?) 
          else 
            #fake some sort of Range that's empty: 
            ::Range.new(first, first, true) 
          end 
        end 
      end
    end 
  end
end

::Range.send :include, Tidbits::CoreExtensions::Range::Intersection