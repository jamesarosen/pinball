module Utilities
  module Controller
    module Format
      
      def self.included(base)
        base.send :include, Utilities::Controller::Format::InstanceMethods
        base.append_before_filter :adjust_format_for_iphone
        base.helper_method :iphone?
        base.alias_method_chain :default_url_options, :format
      end

      module InstanceMethods
        def iphone?
          ( development? && params[:iphone] ) ||
          ( request.env["HTTP_USER_AGENT"] && request.env["HTTP_USER_AGENT"][/(iPhone|iPod)/] )
        end

        def adjust_format_for_iphone
          request.format = :iphone if iphone?
        end
        
        def default_url_options_with_format(options = {})
          format = request.format ? request.format.to_sym.to_s : 'html'
          format = 'html' if ['iphone', 'all'].include?(format)
          { :format => format }.merge(options)
        end
      end
      
    end
  end
end

#only define once, else infinite recursion:
unless ActionController::Routing::Route.method_defined?(:append_query_string_with_deleting_format)
  ActionController::Routing::Route.class_eval do
    def append_query_string_with_deleting_format(path, hash, query_keys=nil)
      hash.delete(:format) unless hash.nil?
      append_query_string_without_deleting_format(path, hash, query_keys)
    end

    alias_method_chain :append_query_string, :deleting_format
  end
end