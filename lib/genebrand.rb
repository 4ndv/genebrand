$:.unshift File.dirname(__FILE__)

def require_all(path)
  glob = File.join(File.dirname(__FILE__), path, '*.rb')
  Dir[glob].each do |f|
    require f
  end
end

require 'rubygems'
require 'colorator'
require 'highline/import'

module Genebrand
  require 'genebrand/command'
  require_all 'genebrand/commands'

  autoload :PosParser, 'genebrand/posparser'
  autoload :VERSION, 'genebrand/version'
  autoload :Logger, 'genebrand/logger'

  class << self
  end
end
