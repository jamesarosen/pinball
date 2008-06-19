module Utilities
  module Controller
    module Environment
      
      def self.included(base)
        base.send :include, Utilities::Controller::Environment::InstanceMethods
        base.helper_method :development?, :test?, :production?
      end
      
      module InstanceMethods
        def development?
          ENV['RAILS_ENV'] == 'development'
        end
      
        def test?
          ENV['RAILS_ENV'] == 'test'
        end
      
        def production?
          !development && !test
        end
      end
      
    end
  end
end