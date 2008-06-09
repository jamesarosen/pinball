module Tidbits #:nodoc: 
  module CoreExtensions #:nodoc:
    module Time #:nodoc: 
      module Until
        def self.included(base)
          base.send :include, Tidbits::CoreExtensions::Time::Until::InstanceMethods
          base.send :alias_method, :to, :until
        end
      
        module InstanceMethods
          def until(end_time)
            Range.new(self, end_time)
          end
        end
      end
    end
  end
end

::Time.send :include, Tidbits::CoreExtensions::Time::Until