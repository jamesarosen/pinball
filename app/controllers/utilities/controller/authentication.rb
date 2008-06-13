module Utilities
  module Controller
    module Authentication

      def self.included(base)
        base.send :include, Utilities::Controller::Authentication::InstanceMethods
        base.send :alias_method, :login_as, :current_user=
        base.helper_method :logged_in?, :current_user
      end

      module InstanceMethods
  
        def logged_in?
          !current_user.nil?
        end

        # Accesses the current user from the session.
        def current_user
          return nil if session[:user].nil?
          return @u unless @u.nil?
          @u = User.find_by_id(session[:user])
        end

        # Store the given user in the session.
        def current_user=(u)
          if u.nil?
            session[:user] = @u = nil
          else
            raise ArgumentError.new("#{u} is not a saved User") unless u.kind_of?(User) && !u.new_record?
            session[:user] = u.id
            @u = u
          end
        end
    
        private
    
        def login_required!
          login_from_http_basic_auth unless logged_in?
          return true if logged_in?
          raise ActionController::UnauthorizedError.new('you must be logged in to access this resource')
        end
    
        def login_from_http_basic_auth
          username, password = get_auth_data
          self.current_user ||= (User.authenticate(username, passwd) || :false) if username && passwd
        end
    
        def login_from_cookie
          return true unless cookies[:auth_token] && !logged_in?
          return true if @u
          user = User.find_by_remember_token(cookies[:auth_token])
          if user && user.remember_token?
            user.remember_me
            self.current_user = user
            cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at  }
            flash[:notice] = "Logged in successfully"
          end
          true
        end
    
        # gets HTTP BASIC auth data
        def get_auth_data
          user, pass = nil, nil
          # extract authorisation credentials 
          if request.env.has_key? 'X-HTTP_AUTHORIZATION' 
            # try to get it where mod_rewrite might have put it 
            authdata = request.env['X-HTTP_AUTHORIZATION'].to_s.split 
          elsif request.env.has_key? 'HTTP_AUTHORIZATION' 
            # this is the regular location 
            authdata = request.env['HTTP_AUTHORIZATION'].to_s.split  
          end 

          # at the moment we only support basic authentication 
          if authdata && authdata[0] == 'Basic' 
            user, pass = Base64.decode64(authdata[1]).split(':')[0..1] 
          end 
          return [user, pass] 
        end
  
      end
  
    end

  end
end