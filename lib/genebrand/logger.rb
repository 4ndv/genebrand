module Genebrand
  class Logger
    def self.error(text)
      puts "ERROR: #{text}".red
    end

    def self.warning(text)
      puts "WARNING: #{text}".yellow
    end

    def self.info(text)
      puts text.bold.cyan
    end

    def self.hint(text)
      puts text.bold
    end

    def self.info(text)
      puts text
    end
  end
end
