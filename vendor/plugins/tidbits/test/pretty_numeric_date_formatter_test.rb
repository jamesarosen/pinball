require File.join(File.dirname(__FILE__), '/test_helper')
require 'active_support'
require 'tidbits/core_extensions/time/pretty_numeric_date_formatter'

class PrettyNumericDateFormatterTest < Test::Unit::TestCase #:nodoc: all
  include Tidbits::CoreExtensions::Time
  
  def setup
    AbstractDateFormatter.class_eval do
      def now
        #now, Wednesday, September 12, 2007
        return ::Time.utc(2007, 9, 12, 12, 0, 0)
      end
    end
    @formatter = PrettyNumericDateFormatter.new
    @now = @formatter.now
  end
  
  def test_uses_seconds_up_to_one_minute
    assert_equal '45 seconds ago', @formatter.call(@now - 45.seconds)
    assert_equal '55 seconds from now', @formatter.call(@now + 55.seconds)
  end
  
  def test_uses_minutes_for_1_to_100_minutes
    assert_equal '1 minute ago', @formatter.call(@now - 66.seconds)
    assert_equal '1 minute from now', @formatter.call(@now + 61.seconds)
    assert_equal '96 minutes ago', @formatter.call(@now - 96.minutes)
    assert_equal '82 minutes from now', @formatter.call(@now + 82.minutes)
  end
  
  def test_uses_hours_for_101_minutes_to_24_hours
    assert_equal '1 hour ago', @formatter.call(@now - 101.minutes)
    assert_equal '1 hour from now', @formatter.call(@now + 115.minutes)
    assert_equal '22 hours ago', @formatter.call(@now - 22.hours)
    assert_equal '23 hours from now', @formatter.call(@now + 23.hours + 59.minutes)
  end
  
  def test_uses_days_for_1_day_to_1_week
    assert_equal '1 day ago', @formatter.call(@now - 27.hours)
    assert_equal '1 day from now', @formatter.call(@now + 40.hours)
    assert_equal '6 days ago', @formatter.call(@now - 6.days - 45.minutes)
    assert_equal '6 days from now', @formatter.call(@now + 6.days + 23.hours + 59.minutes)
  end
  
  def test_uses_weeks_for_1_week_to_1_month
    assert_equal '1 week ago', @formatter.call(@now - 7.days)
    assert_equal '1 week from now', @formatter.call(@now + 7.days + 1.minute)
    assert_equal '4 weeks ago', @formatter.call(@now - 4.weeks)
    assert_equal '4 weeks from now', @formatter.call(@now + 4.weeks + 7.minutes)
  end
  
  def test_uses_months_for_1_month_to_1_year
    assert_equal '1 month ago', @formatter.call(@now - 32.days)
    assert_equal '1 month from now', @formatter.call(@now + 31.days + 5.minutes)
    assert_equal '11 months ago', @formatter.call(@now - 11.months - 19.days)
    assert_equal '11 months from now', @formatter.call(@now + 11.months + 19.days)
  end
  
end