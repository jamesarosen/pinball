require 'tidbits/core_extensions/time/abstract_date_formatter'

module Tidbits #:nodoc: 
  module CoreExtensions #:nodoc: 
    module Time #:nodoc: 
      class PrettySimpleDateFormatter < AbstractDateFormatter
        
        def format(date_or_time)
          date = date_or_time.utc
          now = self.now.utc

          diff = (now - date).abs
          earlier = now > date
          later = !earlier
      
          if diff < 1.day && date.day == now.day && earlier
            return 'earlier today'
          elsif diff < 1.day && date.day == now.day && later
            return 'later today'
          elsif diff < 2.days && date.day == (now - 1.day).utc.day
            return 'yesterday'
          elsif diff < 2.days && date.day == (now + 1.day).utc.day
            return 'tomorrow'
          elsif diff < 1.week && date.wday < now.wday && earlier
            return 'earlier this week'
          elsif diff < 1.week && date.wday > now.wday && later
            return 'later this week'
          elsif diff < 1.week && earlier
            return 'last week'
          elsif diff < 1.week && later
            return 'next week'
          elsif diff < 2.weeks && date.wday < now.wday && earlier
            return 'last week'
          elsif diff < 2.weeks && date.wday > now.wday && later
            return 'next week'
          elsif diff < 1.month && date.month == now.month && earlier
            return 'earlier this month'
          elsif diff < 1.month && date.month == now.month && later
            return 'later this month'
          elsif diff < 2.months && date.month == (now - 1.month).utc.month
            return 'last month'
          elsif diff < 2.months && date.month == (now + 1.month).utc.month
            return 'next month'
          elsif diff < 1.year && date.year == now.year && earlier
            return 'earlier this year'
          elsif diff < 1.year && date.year == now.year && later
            return 'later this year'
          elsif diff < 2.years && date.year == (now - 1.year).utc.year
            return 'last year'
          elsif diff < 2.years && date.year == (now + 1.year).utc.year
            return 'next year'
          else
            return PrettyNumericDateFormatter.new.call(date_or_time)
          end
        end
      end
    end
  end
end