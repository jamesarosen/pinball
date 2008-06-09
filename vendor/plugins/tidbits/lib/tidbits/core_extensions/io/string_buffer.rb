require 'tidbits/core_extensions/io/sink'

module Tidbits #:nodoc:
  module CoreExtensions #:nodoc:
    module IO #:nodoc:
    
      # A real StringBuffer. None of this StringIO crap
      # that doesn't really act like an IO.  Instances
      # of this class actually do the right thing when
      # sent <<, write, and the rest.
      class StringBuffer
        
        include Tidbits::CoreExtensions::IO::Sink
        
        def initialize
          @strings = []
        end
        
        # Append +string+ to this buffer.
        # @returns +self+ so appends can be chained.
        def write(string)
          assert_write_open!
          @strings << string.to_s
          self
        end
        
        # alias for +write(string)+
        def <<(string); write(string); end
        
        # @returns a single String composed of all of the
        # Strings written to this buffer.
        def to_s
          @strings.join("\n")
        end
      
      end
    
    end
  end
end