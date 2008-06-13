module Utilities
  module Controller

    module Authorization
  
      def self.included(base)
        base.extend Utilities::Controller::Authorization::ClassMethods
        base.send :include, Utilities::Controller::Authorization::InstanceMethods
        base.helper_method :is_self?
      end
  
      module ClassMethods
    
        def requires_login(options = {})
          append_before_filter :login_required!, options
        end
    
        def requires_is_self(options = {})
          append_before_filter :login_required!, options
          append_before_filter :is_self_required!, options
        end
    
      end
  
      module InstanceMethods
    
        def is_self?(profile = nil)
          profile ||= requested_profile
          !profile.nil? && logged_in? && current_user.profile == profile
        end

        private
    
        def is_self_required!(p = nil)
          raise ActionController::ForbiddenError.new('you are not authorized to access this resource') unless is_self?(p)
        end
    
      end
  
    end
    
  end
end