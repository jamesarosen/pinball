ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

class Test::Unit::TestCase
  # Transactional fixtures accelerate your tests by wrapping each test method
  # in a transaction that's rolled back on completion.  This ensures that the
  # test database remains unchanged so your fixtures don't have to be reloaded
  # between every test method.  Fewer database queries means faster tests.
  #
  # Read Mike Clark's excellent walkthrough at
  #   http://clarkware.com/cgi/blosxom/2005/10/24#Rails10FastTesting
  #
  # Every Active Record database supports transactions except MyISAM tables
  # in MySQL.  Turn off transactional fixtures in this case; however, if you
  # don't care one way or the other, switching from MyISAM to InnoDB tables
  # is recommended.
  #
  # The only drawback to using transactional fixtures is when you actually 
  # need to test transactions.  Since your test is bracketed by a transaction,
  # any transactions started in your code will be automatically rolled back.
  self.use_transactional_fixtures = true

  # Instantiated fixtures are slow, but give you @david where otherwise you
  # would need people(:david).  If you don't want to migrate your existing
  # test cases which use the @david style and don't mind the speed hit (each
  # instantiated fixtures translates to a database query per test method),
  # then set this back to true.
  self.use_instantiated_fixtures  = false

  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  set_fixture_class :locations => Location::Base
end

ActionController::TestCase.class_eval do
  def setup_controller_request_and_response_with_session
    setup_controller_request_and_response_without_session
    @session = @controller.session = @request.session
  end
  
  alias_method_chain :setup_controller_request_and_response, :session
  
  def logged_in?
    @controller.logged_in?
  end
  
  def current_user
    @controller.current_user
  end
  
  def process_with_default_format(action, parameters = nil, session = nil, flash = nil)
    process_without_default_format(action, {:format => 'html'}.merge(parameters || {}), session, flash)
  end
  
  alias_method_chain :process, :default_format
end

module TestHelperMethods
  
  def assert_flash(val)
    assert_contains flash.values, val, ", Flash: #{flash.inspect}"
  end
  
  def somebody_other_than(sym_or_user)
    result = if sym_or_user.nil?
      User.find(:first)
    else
      id = sym_or_user.kind_of?(User) ? sym_or_user.id : users(sym_or_user).id
      User.find(:first, :conditions => ['id <> ?', id])
    end
    raise ArgumentError.new("Could not find anybody other than #{sym_or_user}") unless result
    result
  end
  alias_method :someone_other_than, :somebody_other_than
  
  def anybody; somebody_other_than(nil); end
  
  def login_as(sym_or_user)
    case sym_or_user
    when nil
      @request.session[:user] = nil
    when User
      @request.session[:user] = sym_or_user.id
    when Symbol
      @request.session[:user] = users(sym_or_user).id
    end
  end
end

module ControllerShoulds
  
  def should_not_find(text = nil, &block)
    should "not find #{text}" do
      block.bind(self).call if block_given?
      assert_response 404
      assert_template 'error/not_found'
    end
  end
  
  def should_be_allowed(text = nil, &block)
    should "be allowed #{text}" do
      block.bind(self).call if block_given?
      assert_response :success
    end
  end
  
  def should_be_unauthorized(text = nil, &block)
    should "be unauthorized #{text}" do
      block.bind(self).call if block_given?
      assert_redirected_to :controller => 'accounts', :action => 'login'
    end
  end
  
  def should_be_forbidden(text = nil, &block)
    should "be forbidden #{text}" do
      block.bind(self).call if block_given?
      assert_response 403
      assert_template 'error/forbidden'
    end
  end
  
end

Test::Unit::TestCase.class_eval do
  include TestHelperMethods
  extend ControllerShoulds
end
