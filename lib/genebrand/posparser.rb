module Genebrand
  class PosParser
    require 'json'
    require 'fileutils'

    def initialize
      init
    end

    def init
      @parsed = {}
      @table = {}
      # Сущ
      @table['N'] = @parsed['noun'] = []
      # Мн. число
      @table['P'] = @parsed['plur'] = []
      # Глаг. прич, пер, непер
      @table['V'] = @parsed['verb_part'] = []
      @table['t'] = @parsed['verb_trans'] = []
      @table['i'] = @parsed['verb_intrans'] = []
      # Прилаг
      @table['A'] = @parsed['adj'] = []
    end

    def parse(filename)
      init

      unless File.exist?(filename)
        fail "File not found: #{filename}"
        return
      end

      puts "Seeding"
      File.open(filename, 'r').each_line do |line|
        data = line.split("\t")

        data[1].split('').each do |partofsp|
          @table[partofsp].push(data[0].downcase) if @table.key?(partofsp)
        end
      end

      @parsed
    end

    def parse_top(filename, top)
      init

      unless File.exist?(filename)
        fail "File not found: #{filename}"
        return
      end

      puts "Load top"
      toparr = []
      File.open(top, 'r').each_line do |line|
        toparr << line.strip.downcase
      end
      puts toparr.count

      puts "Seeding"
      it = 0
      File.open(filename, 'r').each_line do |line|
        data = line.split("\t")

        if toparr.include?(data[0])
          data[1].split('').each do |partofsp|
            @table[partofsp].push(data[0].downcase) if @table.key?(partofsp)
          end
        end
        it+=1
        if it % 10000 == 0
          puts it
        end
      end

      @parsed
    end

    def preseed(filename)
      init

      prsdata = []

      unless File.exist?(filename)
        fail "File not found: #{filename}"
        return
      end

      puts "Preseed"
      File.open(filename, 'r').each_line do |line|
        data = line.split("\t")

        if !is_numeric?(data[0]) && (!/\A[a-zA-Z0-9]{2,10}\z/.match(data[0]).nil?)
          prsdata << line
        end
      end

      prsdata
    end

    def parseandsave(filename, to)
      FileUtils.mkdir_p 'lib/data'
      File.open(to, 'w+') { |f| f.write(parse(filename).to_json) }
    end

    def parseandsave_preseed(filename, to)
      FileUtils.mkdir_p 'lib/data'
      File.open(to, 'w+') do |f|
        write = preseed(filename)
        write.each do |line|
          f.write(line)
        end
      end
    end

    def parseandsave_top(filename, top, to)
      FileUtils.mkdir_p 'lib/data'
      File.open(to, 'w+') { |f| f.write(parse_top(filename, top).to_json) }
    end

    def is_numeric?(obj)
      obj.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/).nil? ? false : true
    end
  end
end
