module Tidbits #:nodoc: 
  module CoreExtensions #:nodoc:
    module Range #:nodoc:
      # adds :empty? to Range 
      module Empty
        # Returns true if (first >= last and exclude_end?) or first > last 
        def empty? 
          # cache in case it's expensive to calculate these: 
          b = self.first 
          e = self.last 

          ((b >= e) && exclude_end?) || (b > e) 
        end 
      end
    end 
  end
end

::Range.send :include, Tidbits::CoreExtensions::Range::Empty