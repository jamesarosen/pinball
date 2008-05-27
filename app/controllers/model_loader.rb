# Loads models from params
module ModelLoader
  
  def self.included(base)
    base.send :include, ModelLoader::InstanceMethods
    base.helper_method :logged_in_profile, :requested_profile, :requested_favorite_location
  end
  
  module InstanceMethods
  
    private
    
    def requested_profile
      @requested_profile ||= User.find(params[:profile_id]).profile
    end
    
    def requested_favorite_location
      @requested_favorite_location ||= params[:favorite_location_id]
    end
    
  end
  
end