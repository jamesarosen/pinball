PROJECT_ROOT = File.expand_path(File.dirname(__FILE__))
$: << File.join(PROJECT_ROOT, 'lib')

require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

task :default => 'test:run'
task :clean => ['doc:clean', 'test:clean', 'gem:clean']

namespace :doc do
  
  desc 'Cleans documentation'
  task :clean => :clobber_generate
  
  Rake::RDocTask.new(:generate) do |rdoc|
    rdoc.rdoc_dir = 'doc'
    rdoc.title    = "Ruby Tidbits Documentation"
    rdoc.rdoc_files.include('lib/**/*.rb')
    rdoc.rdoc_files.include('README.txt')
    rdoc.options << '--line-numbers'
    rdoc.options << '--inline-source'
    rdoc.options << '--main' << 'README.txt'
  end
end

namespace :test do

  LIB_DIRECTORIES = FileList.new do |fl|
    fl.include "#{PROJECT_ROOT}/lib"
  end

  TEST_FILES = FileList.new do |fl|
    fl.include "#{PROJECT_ROOT}/test/**/*_test.rb"
    fl.exclude "#{PROJECT_ROOT}/test/test_helper.rb"
    fl.exclude "#{PROJECT_ROOT}/test/lib/**/*.rb"
  end

  desc 'Run all tests'
  Rake::TestTask.new(:run) do |t|
    t.libs = LIB_DIRECTORIES
    t.test_files = TEST_FILES
    t.verbose = true
  end
  
  # clean up after run
  task :run do
    Rake::Task['test:clean'].invoke
  end
  
  task :clean do
    rm_r 'tmp' if File.exists?('tmp')
  end
  
end

namespace :gem do
  
  GENERATED_GEMS = FileList.new do |fl|
    fl.include "#{PROJECT_ROOT}/ruby-tidbits*.gem"
    fl.exclude "#{PROJECT_ROOT}/**/*.gemspec"  # just in case
  end

  task :build do
    system 'gem build ruby-tidbits.gemspec'
  end
  
  task :clean do
    GENERATED_GEMS.each do |f|
      rm f if File.exists?(f)
    end
  end
  
end