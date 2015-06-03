module Genebrand
  class New < Command
    class << self
      def load_command(p)
        p.command(:new) do |c|
          c.syntax 'new'
          c.description 'Generates new brand name'
          c.alias(:brand)

          c.action do |args, options|
            self.process(args, options)
          end
        end
      end

      def process(args, options)
        puts "Hello! Let's generate some brands!".cyan
        puts

        brand = Array.new
        stopit = false

        until stopit
          choose do |menu|
            menu.prompt = "What should we add?".yellow

            menu.choice("Any word") { brand.push(ask("Enter word (English, no spaces and punctiatio)")) }
            menu.choice("Specific part of speech") { say "Specific part of speech" }
            menu.choice("Enough, show me some brands!")
          end
        end
      end
    end
  end
end
