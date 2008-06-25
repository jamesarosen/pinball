# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include Utilities::Controller::Authentication
  include Utilities::Controller::Authorization
  include Utilities::Controller::ErrorHandling
  include Utilities::Controller::ModelLoader
  include Utilities::Controller::Environment
  include Utilities::Controller::Format
  include Utilities::Controller::Inflection
  include Utilities::Controller::Sidebar
  
  append_before_filter :load_default_sidebar_widgets
  
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '68b21125675c4e41e21fda4e5c9d0301'
  
  layout 'default'
  
  private
  
  attr_accessor :return_to_after_login_location
  
  def load_default_sidebar_widgets
    if logged_in?
      sidebar_widget :location
      sidebar_widget :social
      sidebar_widget :settings
    else
      sidebar_widget :help
    end
    true
  end
  
end
