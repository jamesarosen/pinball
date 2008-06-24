require 'action_controller/base'
require 'action_view/base'

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

module Utilities
  module Controller

    module ErrorHandling

      def self.included(base)
        add_rescue_froms(base)
        base.send :include, Utilities::Controller::ErrorHandling::InstanceMethods
        base.alias_method_chain :rescue_action, :handler_check
      end
  
      def self.add_rescue_froms(base)
        base.rescue_from ActiveRecord::RecordNotFound, :with => :not_found
        base.rescue_from ActionController::UnknownAction, :with => :not_found
        base.rescue_from ActionView::MissingTemplate, :with => :not_found
        base.rescue_from ActionController::RoutingError, :with => :not_found
        base.rescue_from ActionController::MethodNotAllowed, :with => :method_not_allowed
        base.rescue_from ActiveRecord::RecordInvalid, :with => :handle_invalid_record
        base.rescue_from ActiveRecord::ConflictedRecordError, :with => :conflict
        base.rescue_from ActionController::UnauthorizedError, :with => :unauthorized
        base.rescue_from ActionController::ForbiddenError, :with => :forbidden
      end
  
      module InstanceMethods
  
        # Dispatch calls rescue_action directly, bypassing the check for registered handlers.
        def rescue_action_with_handler_check(exception)
          return if rescue_action_with_handler(exception)
          rescue_action_without_handler_check(exception)
        end
  
        private
    
        def perform_action_with_rescue #:nodoc:
          perform_action_without_rescue
        rescue Exception => exception  # errors from action performed
          return if rescue_action_with_handler(exception)
          rescue_action_without_handler_check(exception)
        end
  
        def unauthorized
          respond_to do |accepts|
            accepts.html do
              flash[:error] = 'You must be logged in to see that page'
              self.return_to_after_login_location = "#{request.request_uri}"
              redirect_to :controller => 'accounts', :action => 'login'
            end
            accepts.xml do
              headers["Status"]           = "Unauthorized"
              headers["WWW-Authenticate"] = %(Basic realm="Seek-You")
              render :text => "Login required", :status => 401
            end
          end
        end

        def forbidden(exception)
          @exception = exception
          render :template => '/error/forbidden', :status => 403
        end

        def not_found(exception)
          @exception = exception
          render :template => '/error/not_found', :status => 404
        end

        def conflict(exception)
          @conflicted_object = exception.conflicted_object
          render :template => '/error/conflict', :status => 409
        end
  
        def method_not_allowed(exception)
          @exception = exception
          exception.handle_response!(response)
          render :template => 'error/method_not_allowed', :status => 405
        end

        def handle_invalid_record(exception)
          @exception = exception
          render :action => (exception.record.new_record? ? :new : :edit), :status => 400
        end
  
      end
  
    end
    
  end
end