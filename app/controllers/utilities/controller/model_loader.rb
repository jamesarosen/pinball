module Utilities
  module Controller

    # Loads models from params
    module ModelLoader
  
      def self.included(base)
        base.extend Utilities::Controller::ModelLoader::ClassMethods
        base.send :include, Utilities::Controller::ModelLoader::InstanceMethods
        base.helper_method :logged_in_profile, :requested_profile, :requested_favorite_location
      end
  
      module ClassMethods
        def requires_profile(opts = {})
          append_before_filter :require_profile!, opts
        end
      end
  
      module InstanceMethods
  
        private
    
        def requested_profile(reload = false)
          safe_load :@profile, Profile, :profile_id, reload
        end
        def require_profile!
          require_exists! requested_profile, Profile, :profile_id
        end
    
        def requested_favorite_location(reload = false)
          @favorite_location = nil if reload
          @favorite_location ||= params[:favorite_location_id]
        end
        def require_favorite_location!
        end
    
    

        def safe_load(variable_name, klass, parameter_name, reload)
          begin
            previous_value = instance_variable_get(variable_name)
            if reload || previous_value.nil?
              instance_variable_set(variable_name, klass.find(params[parameter_name]))
            else
              previous_value
            end
          rescue ActiveRecord::RecordNotFound => e
            nil #swallow it; must have a statement here for coverage to see the line
          end
        end
    
        def require_exists!(instance, klass, parameter_name)
          raise error_for(klass, parameter_name) if instance.nil?
        end
    
        def error_for(klass, parameter_name)
          if params[parameter_name]
            msg = "Could not find #{klass} with id #{params[parameter_name]}"
          else
            msg = "Parameter #{parameter_name} is required"
          end
          ActiveRecord::RecordNotFound.new(msg)
        end
    
      end
  
    end
    
  end
end