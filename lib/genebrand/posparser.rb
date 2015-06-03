module Genebrand
  class PosParser
    def parse(filename)
      if not File.exists?(filename)
        raise FileNotFoundException
        return
      end

      parsed = Hash.new
      table = Hash.new
      # Сущ
      table["N"] = parsed[:noun] = Array.new
      # Мн. число
      table["P"] = parsed[:plur] = Array.new
      # Глаг. прич, пер, непер
      table["V"] = parsed[:verb_part] = Array.new
      table["t"] = parsed[:verb_trans] = Array.new
      table["i"] = parsed[:verb_intrans] = Array.new
      # Прилаг
      table["A"] = parsed[:adj] = Array.new

      File.open(filename, 'r').each_line do |line|
        data = line.split("\t")
        data[1].split("").each do |partofsp|
          if table.has_key?(partofsp)
            table[partofsp].push(data[0])
          end
        end
      end

      return parsed
    end
  end
end
