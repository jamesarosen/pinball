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
  is_grammatical
  
  append_before_filter :load_grammatical_context
  
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '68b21125675c4e41e21fda4e5c9d0301'
  
  layout 'default'
  
  private
  
  attr_accessor :return_to_after_login_location
  
  def load_grammatical_context
    audience = logged_in? ? current_user.profile : nil
    subject = requested_profile
    self.grammatical_context = Grammar::GrammaticalContext.new(:subject => subject, :audience => audience)
  end
  
end
