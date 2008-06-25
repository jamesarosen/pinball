module Utilities
  module Controller

    module Authorization
      
      class RequiresAuthorizationFilter
        def initialize(setting_name)
          @setting_name = setting_name
        end
        def filter(controller)
          if controller.authorized?(@setting_name)
            true
          else
            controller.unauthorized_or_forbidden('You are not authorized to access this resource')
            false
          end
        end
      end
  
      def self.included(base)
        base.extend Utilities::Controller::Authorization::ClassMethods
        base.send :include, Utilities::Controller::Authorization::InstanceMethods
        base.helper_method :is_self?, :authorized?
      end
  
      module ClassMethods
    
        def requires_login(options = {})
          append_before_filter :login_required!, options
        end
    
        def requires_is_self(options = {})
          append_before_filter :is_self_required!, options
        end
        
        def requires_authorization(setting_name, options = {})
          append_before_filter Authorization::RequiresAuthorizationFilter.new(setting_name), options
        end
    
      end
  
      module InstanceMethods
    
        def is_self?(profile = nil)
          profile ||= requested_profile
          !profile.nil? && logged_in? && current_user.profile == profile
        end
        
        def authorized?(setting_name, subject = nil, audience = nil)
          subject ||= requested_profile
          raise ArgumentError.new('Subject and requested_profile cannot both be nil') unless subject
          audience ||= current_user.profile if logged_in?
          subject.allows?(setting_name, audience)
        end

        private
    
        def is_self_required!(p = nil)
          return false unless login_required!
          is_self?(p) ? true : unauthorized_or_forbidden('You are not authorized to access this resource') 
        end
    
      end
  
    end
    
  end
end