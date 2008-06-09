module Tidbits #:nodoc:
  module CoreExtensions #:nodoc:
    module IO #:nodoc:
      
      # A Sink that duplicates everything written to two other Sinks.
      module Tee
        
        include Tidbits::CoreExtensions::IO::Pipe
        
        def initialize(sink1, sink2)
          @sink1, @sink2 = sink1, sink2
        end
        
        def write(string)
          assert_write_open!
          @sink1.write(string)
          @sink2.write(string)
        end
        
      end
      
    end
  end
end