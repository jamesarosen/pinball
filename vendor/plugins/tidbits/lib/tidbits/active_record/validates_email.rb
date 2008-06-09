module Tidbits #:nodoc: 
  module ActiveRecord #:nodoc: 
    module ValidatesEmail
      def self.included(base)
        base.extend Tidbits::ActiveRecord::ValidatesEmail::ClassMethods
      end
      
      module ClassMethods
        def validates_email(*attr_names)
          options = attr_names.extract_options!.symbolize_keys!
          configuration = { :on => :save, :allow_blank => true, :message => ::ActiveRecord::Errors.default_error_messages[:invalid], :with => Tidbits::ActiveRecord::ValidatesEmail::SIMPLE_EMAIL_ADDRESS_REGEX }
          configuration.update(options)
          attr_names = [:email] if attr_names.nil? or attr_names.empty?
          raise ArgumentError.new(':with must be a regular expression') unless configuration[:with].is_a?(Regexp)
          validates_format_of(attr_names, configuration)
        end
        
        def valid_tld?(tld)
        end
      end
    
      unless const_defined?(:SIMPLE_EMAIL_ADDRESS_REGEX)
        SIMPLE_EMAIL_ADDRESS_REGEX = /\A[^@\s]+@(?:[[:alnum:]-]+\.)+[[:alpha:]]{2,}\Z/i
      end
      
    end
  end
end

::ActiveRecord::Base.send :include, Tidbits::ActiveRecord::ValidatesEmail