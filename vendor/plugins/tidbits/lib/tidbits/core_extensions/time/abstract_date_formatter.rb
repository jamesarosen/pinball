module Tidbits #:nodoc: 
  module CoreExtensions #:nodoc: 
    module Time #:nodoc: 
      class AbstractDateFormatter
        def now
          begin
            TzTime.now
          rescue NameError
            ::Time.now
          end
        end
    
        def format(date_or_time)
          raise NotImplementedError.new('implementing classes must define format(date_or_time)')
        end
        
        def call(d); format(d); end
      end
    end
  end
end