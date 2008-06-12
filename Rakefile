# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

namespace :db do
  namespace :test do
    
    desc 'Drop the dev and test dbs, drop the schema, rebuild from migrations'
    task :rebuild do
      rm 'db/development.sqlite3' if File.exist?('db/development.sqlite3')
      rm 'db/test.sqlite3' if File.exist?('db/test.sqlite3')
      rm 'db/schema.rb' if File.exist?('db/schema.rb')
      Rake::Task['db:migrate'].invoke
      Rake::Task['db:test:prepare'].invoke
    end
    
  end
end
  