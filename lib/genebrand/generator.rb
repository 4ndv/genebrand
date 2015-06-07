module Genebrand
  class Generator
    require 'resolv'

    attr_reader :words
    attr_accessor :nowhois

    def initialize(filename)
      @words = JSON.parse(File.read(File.join(Gem::Specification.find_by_name('genebrand').gem_dir, "lib/data/#{filename}")))
      @filtername = {
        minlen: "Minimum length:",
        maxlen: "Maximum length:",
        starts: "Starts with:",
        ends: "Ends with:",
        contains: "Contains:"
      }
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
      i = 0

      info.each do |item|
        if item[:type] == :word
          puts "#{i += 1}. Word: #{item[:word]}".green
        elsif item[:type] == :part
          puts "#{i += 1}. Part of speech: #{item[:part]}".green
          puts 'Filters:'
          item[:filters].each do |filter, value|
            puts "#{@filtername[filter]} value"
          end
        end
      end
    end

    def filter(parts, filter, value)
      case filter
      when :minlen
        parts = parts.select { |i| i[/^.{#{value},}$/] }
      when :maxlen
        parts = parts.select { |i| i[/^.{,#{value}}$/] }
      when :starts
        parts = parts.select { |i| i[/^#{value}.*$/i] }
      when :ends
        parts = parts.select { |i| i[/^.*#{value}$/i] }
      when :contains
        parts = parts.select { |i| i[/^.*(#{value}).*$/i] }
      end
      parts
    end

    def applyfilters(part)
      parts = @words[part]
      item[:filters].each do |filter, value|
        parts = filter(parts, filter, value)
      end

      parts
    end

    def prepareparts(info)
      gener = []
      puts 'Fetching variants...'
      info.each do |item|
        if item[:type] == :word
          gener.push(item[:word])
        elsif item[:type] == :part
          parts = applyfilters(item[:part])
          if parts.count > 0
            gener.push(parts)
          else
            Genebrand::Logger.warning '0 variants for that part, will be skipped'
          end
        end
      end

      gener
    end

    def generateone(gener)
      itemd = ''

      gener.each_with_index do |item, index|
        if item.is_a? Array
          ind = rand(gener[index].count)
          itemd << gener[index][ind].capitalize
        else
          itemd << gener[index].capitalize
        end
      end

      itemd
    end

    def proceedgen(gener)
      i = 0
      loop do

        itemd = generateone(gener)
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

      if @nowhois
        puts 'Brand'
      else
        puts "Whois info\tBrand"
      end

      proceedgen(gener)
    end
  end
end
