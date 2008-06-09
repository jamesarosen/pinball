require File.dirname(__FILE__) + '/test_helper'
require 'tidbits/core_extensions/regexp/concatenation'

class RegexConcatenationTest < Test::Unit::TestCase
  
  def test_simple_concatenation
    assert('foobar' =~ /foo/ + /bar/)
  end
  
  def test_drops_line_start_from_operand
    assert('foobar' =~ /foo/ + /^bar/)
  end
  
  def test_drops_line_end_from_self
    assert('foobar' =~ /foo$/ + /bar/)
  end
  
  def test_does_not_drop_escaped_dollar_sign_from_end_of_self
    assert('foo$bar' =~ /foo\$/ + /bar/)
  end
  
  def test_does_drop_dollar_sign_after_escaped_backslash
    assert('foo\bar' =~ /foo\\$/ + /bar/)
    assert('foo\\bar' =~ /foo\\$/ + /bar/)
  end
  
end