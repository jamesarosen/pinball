require File.join(File.dirname(__FILE__), '/test_helper')
require 'tidbits/core_extensions/time/abstract_date_formatter'

class AbstractDateFormatterTest < Test::Unit::TestCase #:nodoc: all
  
  def setup
    @formatter = Tidbits::CoreExtensions::Time::AbstractDateFormatter.new
  end
  
  def test_now
    before = ::Time.now
    now = @formatter.now
    after = ::Time.now
    
    assert before <= now
    assert now <= after
  end
  
  def test_call_not_implemented
    assert_raise(NotImplementedError) { @formatter.call(::Time.now) }
  end
  
end