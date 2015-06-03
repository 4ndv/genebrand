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
        puts "Hello! Let's generate some brands!"
        puts
        choose do |menu|
          menu.prompt = "What should we add?"

          menu.choice(:word) { say "Any word" }
          menu.choice(:spec) { say "Specific part of speech" }
        end
      end
    end
  end
end
