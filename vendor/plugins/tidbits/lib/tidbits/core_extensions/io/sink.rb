module Tidbits #:nodoc:
  module CoreExtensions #:nodoc:
    module IO #:nodoc:
      
      # Essentially the "write" half of IO with some caveats:
      # * including classes MUST define write(string)
      # * does not set or use the global IO varaibles ($., $_, etc.) during operation
      module Sink
        
        # Closes the sink to writing.
        # @returns nil.
        def close_write
          @write_closed = true
          nil
        end

        # @returns whether the sink is closed to writing.
        def write_closed?
          @write_closed
        end
        
        def write(string)
          raise NotImplementedError.new('classes including Source MUST define write(string)')
        end
        
        def <<(string); write(string); end
        
        private
        
        # Helper method for classes including Sink.
        # @raises IOError if the sink is closed to writing.
        def assert_write_open!
          raise IOError.new('the sink is closed to writing') if write_closed?
        end
        
        
      end
      
    end
  end
end