module Utilities
  module Controller
    module Inflection
      
      def self.included(base)
        base.send :include, Grammar::Ext::ActionController
        base.send :include, Utilities::Controller::Inflection::InstanceMethods
        base.append_before_filter :load_grammatical_context
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
        
        def load_grammatical_context
          audience = logged_in? ? current_user.profile : 'Nobody'
          subject = requested_profile
          self.grammatical_context = Grammar::GrammaticalContext.new(:subject => subject, :audience => audience)
        end
        
      end
      
    end
  end
end