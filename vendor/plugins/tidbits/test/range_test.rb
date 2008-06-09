require File.join(File.dirname(__FILE__), '/test_helper')
require 'tidbits/core_extensions/range/intersection'
require 'tidbits/core_extensions/range/empty'

::Range.class_eval do
  def inspect
    to_s
  end
end
  
class RangeTest < Test::Unit::TestCase #:nodoc: all

  attr_reader :a, :b, :c, :d

  def setup
    @a, @b, @c, @d = 6.minutes.ago, 2.minutes.ago, 2.minutes.from_now, 6.minutes.from_now
    #can't do with a loop, b/c the block variable isn't available to the #inspect scope
    @a.instance_eval { def to_s; 'a'; end; }
    @b.instance_eval { def to_s; 'b'; end; }
    @c.instance_eval { def to_s; 'c'; end; }
    @d.instance_eval { def to_s; 'd'; end; }
  end
  
  def empty_range
    [a...a]
  end
 	def test_start_greater_than_end_not_empty 
 	  assert !(5..9).empty? 
 	end 
 	
 	def test_start_equal_end_with_inclusive_end_not_empty 
 	  assert !(12..12).empty? 
 	end 
 	
 	def test_start_equal_end_with_exclusive_end_empty 
 	  assert((99...99).empty?) 
 	end 
 	
 	def test_start_greater_than_end_empty 
 	  assert((4..1).empty?) 
 	end 
 	
 	def test_and_identical 
 	  assert_equal(('c'..'m'), (('c'..'m') & ('c'..'m'))) 
 	end 
 	
 	def test_and_identical_with_exclusive_end 
 	  assert_equal(('c'...'m'), (('c'..'m') & ('c'...'m'))) 
 	end 
 	
 	def test_and_includes 
 	  assert_equal(('b'..'c'), (('a'..'z') & ('b'..'c'))) 
 	end 
 	
 	def test_and_included_by 
 	  assert_equal(('j'..'p'), (('j'..'p') & ('a'..'z'))) 
 	end 
 	
 	def test_and_edge_touch 
 	  assert_equal(('m'..'m'), (('a'..'m') & ('m'..'n'))) 
 	end 
 	
 	def test_and_edge_touch_with_exclusive_end 
 	  assert_equal(('m'...'m'), (('a'...'m') & ('m'..'n'))) 
 	end 
 	
 	def test_and_overlap 
 	  assert_equal(('g'..'t'), (('g'..'z') & ('a'..'t'))) 
 	end 
 	
 	def test_and_overlap_with_exclusive_end 
 	  assert_equal(('k'...'r'), (('k'..'z') & ('d'...'r'))) 
 	end
 	
 	def test_and_no_overlap
 	  assert(((2..19) & (44..999)).empty?)
  end
 	
 	def test_and_empty 
 	  assert_equal(('c'...'c'), (('a'..'z')  & ('c'...'c'))) 
 	end 
 	
 	def test_empty_and 
 	  assert_equal(('f'...'c'), (('f'...'c') & ('a'..'z'))) 
 	end

end