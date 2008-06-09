Gem::Specification.new do |s|
  s.name = 'ruby-tidbits'
  s.version = "0.0.2"
  s.description = 'Ruby Tidbits is a collection of unrelated little helpers for Ruby and Rails'
  s.summary = s.description
  s.authors = ["James Rosen"]
  s.date = '2008-05-01'
  s.email = 'james.a.rosen@gmail.com'
  s.homepage = ["http://github.com/gcnovus/ruby-tidbits"]
  
  s.specification_version = 2 if s.respond_to?(:specification_version=)
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to?(:required_rubygems_version=)
  s.rubygems_version = '1.1.0'
  
  s.require_paths = ["lib"]
  s.files = ['Rakefile', 'README.txt'] + Dir.glob('lib/**/*.*')
  s.test_files = ['test/test_helper.rb'] + Dir.glob('test/**/*_test.rb')
  
  s.has_rdoc = true
  s.rdoc_options = ["--main", "README.txt"]
  s.extra_rdoc_files = ['README.txt']
end