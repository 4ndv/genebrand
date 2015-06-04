module Genebrand
  class New < Command
    class << self
      require 'json'

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
        @gen = Genebrand::Generator.new

        until stopit
          choose do |menu|
            menu.prompt = "What should we add?".yellow

            menu.choice("Any word") { brand.push({ :type => "word", :word => ask("Enter word (English, no spaces and punctiatio)")}) and puts }
            menu.choice("Specific part of speech") { brand.push(pickpart) }

            if brand.length > 1
              menu.choice("Enough, show me some brands!") { stopit = true }
            end
          end
        end
      end

      def pickpart
        puts

        data = { :type => "part" }
        part = ""

        choose do |menu|
          menu.prompt = "What part of speech should we add?".yellow

          menu.choice("Noun (#{@gen.words["noun"].count} in db)") { part = "noun" }
          menu.choice("Plural (#{@gen.words["plur"].count} in db)") { part = "plur" }
          menu.choice("Verb participle (#{@gen.words["verb_part"].count} in db)") { part = "verb_part" }
          menu.choice("Verb transitive (#{@gen.words["verb_trans"].count} in db)") { part = "verb_trans" }
          menu.choice("Verb intransitive (#{@gen.words["verb_intrans"].count} in db)") { part = "verb_intrans" }
          menu.choice("Adjective (#{@gen.words["adj"].count} in db)") { part = "adj" }
        end

        data[:part] = part

        addfilters(data)
      end

      def addfilters(data)
        if data[:filters] == nil
          data[:filters] = Array.new
        end
      end
    end
  end
end