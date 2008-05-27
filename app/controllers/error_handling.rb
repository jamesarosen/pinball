#require 'action_controller/base'

module ActionController
  class UnauthorizedError < ActionController::ActionControllerError
  end
  class ForbiddenError < ActionController::ActionControllerError
  end
end

module ActiveRecord
  class ConflictedRecordError < ActiveRecordError
    attr_reader :conflicted_object
    def initialize(conflicted_object, msg = nil)
      super(msg)
      @conflicted_object = conflicted_object
    end
  end
end

module ErrorHandling

  def self.included(base)
    base.rescue_from ActiveRecord::RecordNotFound, :with => :not_found
    base.rescue_from ActionController::UnknownAction, :with => :not_found
    base.rescue_from ActionController::MissingTemplate, :with => :not_found
    base.rescue_from ActiveRecord::RecordInvalid, :with => :handle_invalid_record
    base.rescue_from ActiveRecord::ConflictedRecordError, :with => :conflict
    base.rescue_from ActionController::UnauthorizedError, :with => :unauthorized
    base.rescue_from ActionController::ForbiddenError, :with => :forbidden
  end
  
  private
  
  def unauthorized
    respond_to do |accepts|
      accepts.html do
        session[:return_to] = "#{request.request_uri}"
        redirect_to :controller => 'accounts', :action => 'login'
      end
      accepts.xml do
        headers["Status"]           = "Unauthorized"
        headers["WWW-Authenticate"] = %(Basic realm="Seek-You")
        render :text => "Login required", :status => 401
      end
    end
  end

  def forbidden
    render :template => '/error/forbidden', :status => 403
  end

  def not_found(exception)
    flash[:error] = exception.to_s
    render :template => '/error/not_found', :status => 404
  end

  def conflict(exception)
    @conflicted_object = exception.conflicted_object
    render :template => '/error/conflict', :status => 409
  end

  def handle_invalid_record(exception)
    render :action => (exception.record.new_record? ? :new : :edit), :status => 400
  end
  
end