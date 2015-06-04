module Genebrand
  class Generator
    attr_reader :words

    def initialize
      @words = JSON.parse(File.read(File.join(Gem::Specification.find_by_name("genebrand").gem_dir, "lib/data/posinfo.json")))
    end

    def generate(info)
      out = Array.new
      
    end
  end
end
