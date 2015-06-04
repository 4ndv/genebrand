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
            process(args, options)
          end
        end
      end

      def process(_args, _options)
        puts "Hello! Let's generate some brands!".cyan
        puts

        brand = []
        stopit = false
        @gen = Genebrand::Generator.new

        catch :parts_done do
          loop do
            choose do |menu|
              menu.prompt = 'What should we add?'.yellow

              menu.choice('String') do
                brand.push(type: :word,
                           word: ask('Enter word (English, no spaces and punctiation, 1-10 symbols)')) do |q|
                  q.validate = /\A[a-zA-Z\d]{1,10}\z/
                end
                puts
              end

              menu.choice('Specific part of speech') { brand.push(pickpart) }

              if brand.length > 1
                menu.choice('Enough, show me some brands!') { throw :parts_done }
              end
            end
          end
        end

        @gen.generate(brand)
      end

      def pickpart
        puts

        data = { type: :part }
        part = ''

        choose do |menu|
          menu.prompt = 'What part of speech should we add?'.yellow

          menu.choice("Noun (#{@gen.words['noun'].count} in db)") { part = 'noun' }
          menu.choice("Plural (#{@gen.words['plur'].count} in db)") { part = 'plur' }
          menu.choice("Verb participle (#{@gen.words['verb_part'].count} in db)") { part = 'verb_part' }
          menu.choice("Verb transitive (#{@gen.words['verb_trans'].count} in db)") { part = 'verb_trans' }
          menu.choice("Verb intransitive (#{@gen.words['verb_intrans'].count} in db)") { part = 'verb_intrans' }
          menu.choice("Adjective (#{@gen.words['adj'].count} in db)") { part = 'adj' }
        end

        data[:part] = part

        addfilters(data)
      end

      def check_filter_conflict(data)
        filters = data[:filters]
        if !filters[:minlen].nil? && !filters[:maxlen].nil?
          if filters[:minlen] > filters[:maxlen]
            filters[:minlen] = nil
            filters[:maxlen] = nil
            Genebrand::Logger.error 'Minimum length should be lesser than maximum, min and max filters was reset'
            return false
          end
        end
        true
      end

      def addfilters(data)
        puts

        data[:filters] = {} if data[:filters].nil?

        catch :filter_done do
          loop do
            choose do |menu|
              menu.prompt = 'Choose filters for this words'.yellow

              check_filter_conflict(data)

              if data[:filters][:minlen].nil?
                menu.choice('Minimum length') do
                  data[:filters][:minlen] = ask('Enter minimum word length (between 1 and 10)  ', Integer) do |q|
                    q.in = 1..10
                  end
                end
              end

              if data[:filters][:maxlen].nil?
                menu.choice('Maximum length') do
                  data[:filters][:maxlen] = ask('Enter maximum word length (between 1 and 10)', Integer) do |q|
                    q.in = 1..10
                  end
                end
              end

              if data[:filters][:starts].nil?
                menu.choice('Starts with') do
                  data[:filters][:starts] = ask('Enter symbols word should start with')
                end
              end

              if data[:filters][:ends].nil?
                menu.choice('Ends with') do
                  data[:filters][:ends] = ask('Enter symbols word should end with')
                end
              end

              if data[:filters][:contains].nil?
                menu.choice('Contains') do
                  data[:filters][:contains] = ask('Enter symbols word should contain')
                end
              end

              menu.choice('Enough filters, next') { throw :filter_done if check_filter_conflict(data) }
            end
          end
        end

        data
      end
    end
  end
end
