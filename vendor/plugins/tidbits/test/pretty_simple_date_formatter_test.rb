require File.join(File.dirname(__FILE__), '/test_helper')
require 'tidbits/core_extensions/time/pretty_simple_date_formatter'

class PrettySimpleDateFormatterTest < Test::Unit::TestCase #:nodoc: all
  include Tidbits::CoreExtensions::Time
  
  def setup
    AbstractDateFormatter.class_eval do
      def now
        #now, Wednesday, September 12, 2007
        return ::Time.utc(2007, 9, 12, 12, 0, 0)
      end
    end
    @formatter = PrettySimpleDateFormatter.new
    @now = @formatter.now
  end
  
  def test_same_day
    assert_equal 'earlier today', @formatter.call(@now - 2.hours)
    assert_equal 'later today', @formatter.call(@now + 2.hours)
  end
  
  def test_yesterday_and_tomorrow
    assert_equal 'yesterday', @formatter.call(@now - 1.day)
    assert_equal 'tomorrow', @formatter.call(@now + 1.day)
  end
  
  def test_same_week
    assert_equal 'earlier this week', @formatter.call(@now - 2.days)
    assert_equal 'later this week', @formatter.call(@now + 2.days)
  end
  
  def test_next_and_last_week
    assert_equal 'last week', @formatter.call(@now - 5.days)
    assert_equal 'next week', @formatter.call(@now + 5.days)
    assert_equal 'last week', @formatter.call(@now - 9.days)
    assert_equal 'next week', @formatter.call(@now + 9.days)
  end

  def test_same_month
    assert_equal 'earlier this month', @formatter.call(@now - 11.days)
    assert_equal 'later this month', @formatter.call(@now + 11.days)
  end

  def test_next_month
    assert_equal 'last month', @formatter.call(@now - 22.days)
    assert_equal 'next month', @formatter.call(@now + 22.days)
  end

  def test_same_year
    assert_equal 'earlier this year', @formatter.call(@now - 2.months)
    assert_equal 'later this year', @formatter.call(@now + 2.months)
  end

  def test_next_year
    assert_equal 'last year', @formatter.call(@now - 14.months)
    assert_equal 'next year', @formatter.call(@now + 14.months)
  end

  def test_differences_greater_than_1_year
    assert_equal '14 years ago', @formatter.call(@now - 14.years - 7.months)
    assert_equal '5 years from now', @formatter.call(@now + 5.years + 6.months)
  end
end