module Genebrand
  class Generator
    attr_reader :words

    def initialize
      @words = JSON.parse(File.read(File.join(Gem::Specification.find_by_name('genebrand').gem_dir, 'lib/data/posinfo.json')))
    end

    def generate(info)
      out = []

      puts
      puts 'Generating brands with these parameters:'.cyan
      puts
      i = 1

      info.each do |item|
        if item[:type] == :word
          puts "#{i}. Word: #{item[:word]}".green
        elsif item[:type] == :part
          puts "#{i}. Part of speech: #{item[:part]}".green
          puts 'Filters:'
          item[:filters].each do |filter, value|
            if filter == :minlen
              puts "Minimum length: #{value}"
            elsif filter == :maxlen
              puts "Maximum length: #{value}"
            elsif filter == :starts
              puts "Starts with: #{value}"
            elsif filter == :ends
              puts "Ends with: #{value}"
            elsif filter == :contains
              puts "Contains: #{value}"
            end
          end
        end

        i += 1
      end
    end
  end
end
