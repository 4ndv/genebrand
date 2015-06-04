module Genebrand
  class PosParser
    require 'json'
    require 'fileutils'

    def initialize
      @parsed = Hash.new
      @table = Hash.new
      # Сущ
      @table["N"] = @parsed["noun"] = Array.new
      # Мн. число
      @table["P"] = @parsed["plur"] = Array.new
      # Глаг. прич, пер, непер
      @table["V"] = @parsed["verb_part"] = Array.new
      @table["t"] = @parsed["verb_trans"] = Array.new
      @table["i"] = @parsed["verb_intrans"] = Array.new
      # Прилаг
      @table["A"] = @parsed["adj"] = Array.new
    end

    def parse(filename)
      if not File.exists?(filename)
        raise "File not found: #{filename}"
        return
      end

      File.open(filename, 'r').each_line do |line|
        data = line.split("\t")

        if !is_numeric?(data[0]) and (/\A[a-zA-Z0-9]{2,10}\z/.match(data[0]) != nil)
          data[1].split("").each do |partofsp|
            if @table.has_key?(partofsp)
              @table[partofsp].push(data[0])
            end
          end
        end
      end

      return @parsed
    end

    def parseandsave(filename)
      FileUtils.mkdir_p 'lib/data'
      File.open("lib/data/posinfo.json", 'w+') {|f| f.write(self.parse(filename).to_json) }
    end

    def is_numeric?(obj)
      obj.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
    end
  end
end
