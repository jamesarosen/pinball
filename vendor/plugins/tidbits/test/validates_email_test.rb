require File.dirname(__FILE__) + '/test_helper'
require File.dirname(__FILE__) + '/active_record_helper'
require 'active_record'
require 'tidbits/active_record/validates_email'

class ValidatesEmailTest < Test::Unit::TestCase
  
  def setup
    @klass = Class.new(ActiveRecord::Base)
    @klass.class_eval do
      set_table_name 'users'
      validates_email
      validates_email :email2, :with => /^[\.\w-]+(\+[\.\w-]+)?@[\.\w-]+$/u
    end
  end

  def test_allows_nil
    p = @klass.new
    assert p.valid?
    assert_nil p.errors.on(:email)
    assert_nil p.errors.on(:email2)
  end
  
  def test_invalid_email
    p = @klass.new(:email => 'not a valid email address')
    assert !p.valid?
    assert p.errors.on(:email)
  end
  
  def test_needs_domain
    p = @klass.new(:email => 'person@')
    assert !p.valid?
    assert p.errors.on(:email)
  end
  
  def test_simple_email
    p = @klass.new(:email => 'person@example.com')
    assert p.valid?
    assert_nil p.errors.on(:email)
  end
  
  def test_plus_email
    p = @klass.new(:email => 'georgette.aiken+secret_code@example.com')
    assert p.valid?
    assert_nil p.errors.on(:email)
  end
  
  def test_custom_with
    p = @klass.new(:email2 => 'ελλεν@αξιος.net')
    assert p.valid?
    assert_nil p.errors.on(:email)
  end
  
end