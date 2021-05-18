# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

begin
  targets = File.open('db/2021-05-18-targets.txt').readlines

  # I was originally using the seed routine as a test case for simple threading of the Domain and Website checks. Ultimately, though, I think that work ought to be moved to a queue/worker type concurrency setup as a part of the main deployment rather than part of the database seeding step. I'm keeping the the code, though, as a gist for future reference.
  while ! targets.empty?
    threads = []
    targets.pop(10).each do |target|
      begin
        puts "Creating Domain: #{target.chomp}"
        threads << Thread.new {
          domain = Domain.find_or_create_by(domain_name: target.chomp)
        }
      rescue => exception
        puts "Exception:", exception
      end
    end
    threads.each(&:join)
    puts "\n\n"
  end
rescue => exception
  puts "Exception:", exception
end