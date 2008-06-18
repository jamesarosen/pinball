module Utilities
  module Controller
    module Inflection
      
      def self.included(base)
        base.send :include, Utilities::Controller::Inflection::InstanceMethods
        base.helper_method :display_name
      end
      
      module InstanceMethods
        
        def display_name(user_or_profile, options = {})
          case user_or_profile
          when User, Profile
            self.grammatical_context.merge(:subject => user_or_profile.profile).subject(options)
          else
            user_or_profile
          end
        end
        
      end
      
    end
  end
end