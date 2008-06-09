RAILS_ROOT = "#{File.dirname(__FILE__)}" unless defined?(RAILS_ROOT)
RAILS_ENV = 'test' unless defined?(RAILS_ENV)
require 'test/unit'
require 'rubygems'

$: << File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
$: << File.expand_path(File.join(File.dirname(__FILE__), 'lib'))

Test::Unit::TestCase.class_eval do
  
  def filename_for_fixture(fixture)
    File.join(File.dirname(__FILE__), 'fixtures', fixture)
  end
  
  def read_fixture_file(fixture)
    File.read(filename_for_fixture(fixture))
  end
  
end