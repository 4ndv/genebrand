require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

task :buildgem do
  require "./lib/genebrand/version"

  `gem uninstall genebrand -x`
  `rm ./genebrand-*.gem`
  `gem build genebrand.gemspec`
  `gem install ./genebrand-#{Genebrand::VERSION}.gem`  
end
