require "bundler/gem_tasks"
require "rspec/core/rake_task"
require 'pry-byebug'
Dir.glob('tasks/*.rake').each { |task_file| load task_file}

RSpec::Core::RakeTask.new(:spec)

task :default => :spec
