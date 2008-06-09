require File.join(File.dirname(__FILE__), '/test_helper')
require 'tidbits/rake/rdoctask'
require 'tidbits/core_extensions/io/string_buffer'

class RDocTaskTest < Test::Unit::TestCase #:nodoc: all
  
  def setup
    @error_io = Tidbits::CoreExtensions::IO::StringBuffer.new
    Rake::Task.clear
    Tidbits::Rake::RDocTask.new do |rdoc|
      rdoc.error_io = @error_io
      rdoc.rdoc_dir = 'tmp'
      rdoc.title    = "Test Documentation"
      rdoc.rdoc_files.include('test/lib/**/*.rb')
      rdoc.extra_files.include('test/fixtures/extra_file.html')
      rdoc.extra_files.include('test/../test/fixtures/extra_file.html')
      rdoc.options << '--line-numbers'
      rdoc.options << '--inline-source'
      rdoc.options << '--main' << 'README.txt'
    end
  end
  
  def test_warns_of_duplicate_files
    assert_equal 'WARNING: multiple files named extra_file.html', @error_io.to_s
  end
  
  def test_defines_tasks
    assert !Rake::Task['rdoc_copy_extra_files'].nil?
    assert !Rake::Task['rdoc_write_extra_links'].nil?
  end
  
  def xtest_copies_extra_files
  end
  
  def xtest_adds_extra_links
  end
  
end