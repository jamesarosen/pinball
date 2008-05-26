# Loads models from params
module ModelLoader
  
  private
  
  def load_logged_in_profile
    @logged_in_profile = 1
  end
  
  def load_requested_profile
    @requested_profile = params[:profile_id]
  end
  
  def load_requested_favorite_location
    @requested_favorite_location = params[:favorite_location_id]
  end
  
end