require File.dirname(__FILE__) + '/test_helper'
require File.dirname(__FILE__) + '/active_record_helper'
require 'active_record'
require 'tidbits/active_record/validates_uri'

class ValidatesUriTest < Test::Unit::TestCase
  
  def setup
    @klass = Class.new(ActiveRecord::Base)
    @klass.class_eval do
      set_table_name 'users'
      validates_uri :blog
      validates_uri :website, :protocols => [:ftp]
    end
  end

  def test_allows_nil
    p = @klass.new
    assert p.valid?
    assert_nil p.errors.on(:blog)
  end
  
  def test_invalid_uri
    p = @klass.new(:blog => 'not a valid URI')
    assert !p.valid?
    assert p.errors.on(:blog)
  end
  
  def test_needs_protocol
    p = @klass.new(:blog => 'www.example.com/blog')
    assert !p.valid?
    assert p.errors.on(:blog)
  end

  def test_invalid_protocol
    p = @klass.new(:blog => 'ftp://blog.example.com')
    assert !p.valid?
    assert p.errors.on(:blog)
  end
  
  def test_simple_uri
    p = @klass.new(:blog => 'http://example.net/blog.html')
    assert p.valid?
    assert_nil p.errors.on(:blog)
  end
  
  def test_uri_with_embedded_username_and_password
    p = @klass.new(:blog => 'https://user:password@example.net/path/to/blog.html')
    assert p.valid?
    assert_nil p.errors.on(:blog)
  end

  def test_uri_with_port
    p = @klass.new(:blog => 'https://example.net:4000/blog')
    assert p.valid?
    assert_nil p.errors.on(:blog)
  end

  def test_uri_with_query
    p = @klass.new(:blog => 'https://blogs.example.net/blog.php?title=my_fave_blog')
    assert p.valid?
    assert_nil p.errors.on(:blog)
  end
  
  def test_custom_protocol
    p = @klass.new(:website => 'ftp://blog.example.com')
    assert p.valid?
    assert_nil p.errors.on(:website)
  end
  
end