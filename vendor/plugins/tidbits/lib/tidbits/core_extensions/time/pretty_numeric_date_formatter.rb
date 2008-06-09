require 'tidbits/core_extensions/time/abstract_date_formatter'

raise 'PrettyNumericDateFormatter requires String to define instance method :pluralize' unless String.instance_method(:pluralize)

module Tidbits #:nodoc: 
  module CoreExtensions #:nodoc: 
    module Time #:nodoc: 
      class PrettyNumericDateFormatter < AbstractDateFormatter
    
        def format(date_or_time)      
          return format_helper(*parse_value_and_unit(date_or_time))
        end
        
        # Override this method to provide internationazliation.
        # +value+ is a positive or negative number, representing "from now" or "ago" respectively.
        # +unit+ is one of [:second, :minute, :hour, :day, :week, :month, :year].
        def format_helper(value, unit)
          "#{pluralize(value.abs, unit.to_s)} #{value >= 0 ? 'from now' : 'ago'}"
        end
        
        private
        
        def parse_value_and_unit(date_or_time)
          date = date_or_time.utc
          now = self.now.utc

          diff = (now - date).abs
          sign = now > date ? -1 : 1

          if diff < 60.seconds
            diff = diff.to_i
            units = :second
          elsif diff < 100.minutes
            diff = (diff / 1.minute).to_i
            units = :minute
          elsif diff < 24.hours
            diff = (diff / 1.hour).to_i
            units = :hour
          elsif diff < 1.week
            diff = (diff / 1.day).to_i
            units = :day
          elsif diff < 1.month
            diff = (diff / 1.week).to_i
            units = :week
          elsif diff < 1.year
            diff = (diff / 1.month).to_i
            units = :month
          else
            diff = (diff / 1.year).to_i
            units = :year
          end
          
          return diff * sign, units
        end
        
        #from ActionView::Helpers::TextHelper
        def pluralize(count, singular, plural = nil)
           "#{count || 0} " + if count == 1 || count == '1'
            singular
          elsif plural
            plural
          else
            singular.pluralize
          end
        end
        
      end
    end
  end
end