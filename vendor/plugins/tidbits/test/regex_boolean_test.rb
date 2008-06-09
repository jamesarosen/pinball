require File.dirname(__FILE__) + '/test_helper'
require 'tidbits/core_extensions/regexp/boolean'

class RegexBooleanTest < Test::Unit::TestCase
  
  def test_simple_not
    assert('foobar' =~ /blub/.inverse)
    assert(!('foobar' =~ /foobar/.inverse))
  end
  
  def test_simple_and
    assert('foobar' =~ /bar/ & /foo/)
    assert(!('foobar' =~ /bar/ & /fdajflkdsjkafkds/))
  end
  
  def test_simple_or
    assert('foobar' =~ /bar/ | /fdsfjklfdslkjdafsljkdf/)
    assert(!('foobar' =~ /fdaflidsjijn/ | /fdsfjklfdslkjdafsljkdf/))
  end
  
  def test_compound_logic
    x_and_y_and_either_a_or_b_but_not_both = /x/ & /y/ & (/a/ | /b/) & (/a/ & /b/).inverse
    assert('aaaxy'    =~ x_and_y_and_either_a_or_b_but_not_both)
    assert(!('abxay'  =~ x_and_y_and_either_a_or_b_but_not_both))
    assert(!('xy'     =~ x_and_y_and_either_a_or_b_but_not_both))
  end
  
end