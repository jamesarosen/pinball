module Utilities
  module Controller
    module Environment
      
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