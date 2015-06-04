module Genebrand
  class Generator
    require 'resolv'

    attr_reader :words

    def initialize(filename)
      @words = JSON.parse(File.read(File.join(Gem::Specification.find_by_name('genebrand').gem_dir, "lib/data/#{filename}")))
    end

    def prettyoutput(domain)
      data = '['

      # A bit hacky, but pretty fast method to guess domain available or not
      resolv = Resolv::DNS.open
      data << (resolv.getresources("#{domain}.com", Resolv::DNS::Resource::IN::NS).count == 0 ? "com".green : "com".red)
      data << ' '
      data << (resolv.getresources("#{domain}.net", Resolv::DNS::Resource::IN::NS).count == 0 ? "net".green : "net".red)
      data << ' '
      data << (resolv.getresources("#{domain}.org", Resolv::DNS::Resource::IN::NS).count == 0 ? "org".green : "org".red)
      data << "]\t"
      data << domain.bold

      return data
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
            Genebrand::Logger.warning "0 variants for that part, will be skipped"
          end
        end
      end

      approx = 1

      gener.each do |item|
        if item.is_a? Array
          approx *= item.count
        end
      end

      #arrdata.reverse!

      puts 'Available variants: '.yellow + approx.to_s.bold
      puts

      puts "Whois info\tBrand"

      finish = false
      i = 0
      while not finish
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

        if i%15 == 0
          puts
          puts "Press any key to see next variants".cyan
          gets
        end
      end
    end
  end
end
