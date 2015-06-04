require 'bundler/gem_tasks'

task :default do
  require './lib/genebrand/version'

  `gem uninstall genebrand -x`
  `rm ./genebrand-*.gem`
  `gem build genebrand.gemspec`
  `gem install ./genebrand-#{Genebrand::VERSION}.gem`
end

task :seed do
  require './lib/genebrand/posparser.rb'

  puts "Parsing all data"
  parser = Genebrand::PosParser.new
  parser.parseandsave('seed/pos.txt', 'data/posinfo.json')

  puts "Parsing with top 100k"
  parser.parseandsave_top('seed/pos.txt', 'seed/100k.txt', 'data/pos100k.json')

  puts "Parsing with top 10k"
  parser.parseandsave_top('seed/pos.txt', 'seed/10k.txt', 'data/pos10k.json')
end
