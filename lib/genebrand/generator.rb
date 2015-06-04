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

      puts
      puts 'Press any key to continue'.cyan
      puts

      puts 'Fetching variants...'
      gener = []
      wordscount = 0
      info.each do |item|
        if item[:type] == :word
          wordscount += 1
          gener.push(item[:word])
        elsif item[:type] == :part
          parts = @words[item[:part]]
          item[:filters].each do |filter, value|
            if filter == :minlen
              parts = parts.select { |i| i[/^.{#{value},}$/] }
            elsif filter == :maxlen
              parts = parts.select { |i| i[/^.{,#{value}}$/] }
            elsif filter == :starts
              parts = parts.select { |i| i[/^#{value}.*$/] }
            elsif filter == :ends
              parts = parts.select { |i| i[/^.*#{value}$/] }
            elsif filter == :contains
              parts = parts.select { |i| i[/^.*(#{value}).*$/] }
            end
          end

          gener.push(parts)
        end
      end

      approx = 1

      gener.each do |item|
        approx *= item.count if item.is_a? Array
      end

      puts 'Available variants: '.yellow + approx.to_s.bold
    end
  end
end
