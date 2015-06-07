module Genebrand
  class Generator
    require 'resolv'

    attr_reader :words
    attr_accessor :nowhois

    def initialize(filename)
      @words = JSON.parse(File.read(File.join(Gem::Specification.find_by_name('genebrand').gem_dir, "lib/data/#{filename}")))
    end

    def is_available?(domain, zone)
      resolv = Resolv::DNS.open
      return resolv.getresources("#{domain}.#{zone}", Resolv::DNS::Resource::IN::NS).count == 0
    end

    def prettyoutput(domain)
      data = ''
      unless @nowhois
        # A bit hacky, but pretty fast method to guess domain available or not
        resolv = Resolv::DNS.open
        com = is_available?(domain, "com") ? 'com'.green : 'com'.red
        net = is_available?(domain, "net") ? 'net'.green : 'net'.red
        org = is_available?(domain, "org") ? 'org'.green : 'org'.red
        data = "[#{com} #{net} #{org}]\t"
      end
      data << domain.bold

      data
    end

    def getinfo(info)
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

    def prepareparts(info)
      gener = []
      puts 'Fetching variants...'
      info.each do |item|
        if item[:type] == :word
          gener.push(item[:word])
        elsif item[:type] == :part
          parts = @words[item[:part]]
          item[:filters].each do |filter, value|
            if filter == :minlen
              parts = parts.select { |i| i[/^.{#{value},}$/] }
            elsif filter == :maxlen
              parts = parts.select { |i| i[/^.{,#{value}}$/] }
            elsif filter == :starts
              parts = parts.select { |i| i[/^#{value}.*$/i] }
            elsif filter == :ends
              parts = parts.select { |i| i[/^.*#{value}$/i] }
            elsif filter == :contains
              parts = parts.select { |i| i[/^.*(#{value}).*$/i] }
            end
          end

          if parts.count > 0
            gener.push(parts)
          else
            Genebrand::Logger.warning '0 variants for that part, will be skipped'
          end
        end
      end

      gener
    end

    def proceedgen(gener)
      if @nowhois
        puts 'Brand'
      else
        puts "Whois info\tBrand"
      end

      i = 0
      loop do
        itemd = ''

        gener.each_with_index do |item, index|
          if item.is_a? Array
            ind = rand(gener[index].count)
            itemd << gener[index][ind].capitalize
          else
            itemd << gener[index].capitalize
          end
        end

        puts prettyoutput(itemd)

        i += 1

        if i % 15 == 0
          puts
          puts 'Press any key to see next variants'.cyan
          gets
        end
      end
    end

    def countvariants(gener)
      approx = 1

      gener.each do |item|
        approx *= item.count if item.is_a? Array
      end

      puts 'Available variants: '.yellow + approx.to_s.bold
      puts
    end

    def generate(info)
      getinfo(info)

      gener = prepareparts(info)

      countvariants(gener)

      proceedgen(gener)
    end
  end
end
