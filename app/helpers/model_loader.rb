# Loads models from params
module ModelLoader
  
  private
  
  def load_logged_in_profile
    @logged_in_profile = session[:logged_in_profile]
  end
  
  def load_requested_profile
    @requested_profile = params[:profile_id]
  end
  
end