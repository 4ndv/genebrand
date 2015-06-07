require 'bundler/gem_tasks'

task :default do
  require './lib/genebrand/version'

  `gem uninstall genebrand -x`
  `rm ./genebrand-*.gem`
  `gem build genebrand.gemspec`
  `gem install ./genebrand-#{Genebrand::VERSION}.gem`
end

task :preseed do
  require './lib/genebrand/posparser.rb'
  parser = Genebrand::PosParser.new
  parser.parseandsave_preseed('seed/pos.txt', 'seed/preseed.txt')
end

task :seed do
  require './lib/genebrand/posparser.rb'
  puts 'May (and will) take a while'
  puts 'Parsing all data'
  parser = Genebrand::PosParser.new
  parser.parseandsave('seed/preseed.txt', 'lib/data/posinfo.json')

  puts 'Parsing with top 100k'
  parser.parseandsave_top('seed/preseed.txt', 'seed/100k.txt', 'lib/data/pos100k.json')

  puts 'Parsing with top 10k'
  parser.parseandsave_top('seed/preseed.txt', 'seed/10k.txt', 'lib/data/pos10k.json')
end
