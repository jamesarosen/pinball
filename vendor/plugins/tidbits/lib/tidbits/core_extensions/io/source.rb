module Tidbits #:nodoc:
  module CoreExtensions #:nodoc:
    module IO #:nodoc:
      
      # Essentially the "read" half of IO with some caveats:
      # * including classes MUST define read(bytes, buffer)
      # * does not set or use the global IO varaibles ($., $_, etc.) during operation
      module Source
        
        # Closes the source to reading.
        # @returns nil.
        def close_read
          @read_closed = true
        end

        # @returns whether the source is closed to reading.
        def read_closed?
          @read_closed
        end
        
        def read(bytes, buffer)
          raise NotImplementedError.new('classes including Source MUST define read(bytes, buffer)')
        end
        
        private
        
        # Helper method for classes including Source.
        # @raises IOError if the sink is closed to reading.
        def assert_read_open!
          raise IOError.new('the source is closed to reading') if read_closed?
        end
        
        
      end
      
    end
  end
end