module Genebrand
  class PosParser
    require 'json'
    require 'fileutils'

    def initialize
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
      unless File.exist?(filename)
        fail "File not found: #{filename}"
        return
      end

      File.open(filename, 'r').each_line do |line|
        data = line.split("\t")

        if !is_numeric?(data[0]) && (!/\A[a-zA-Z0-9]{2,10}\z/.match(data[0]).nil?)
          data[1].split('').each do |partofsp|
            @table[partofsp].push(data[0]) if @table.key?(partofsp)
          end
        end
      end

      @parsed
    end

    def parseandsave(filename)
      FileUtils.mkdir_p 'lib/data'
      File.open('lib/data/posinfo.json', 'w+') { |f| f.write(parse(filename).to_json) }
    end

    def is_numeric?(obj)
      obj.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/).nil? ? false : true
    end
  end
end
