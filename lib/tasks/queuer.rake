desc 'Queue up some jobs!'
task :queuer => :environment do
    puts "Queuing up some jobs!"

    randoms = Set.new

    # Seed with anything that hasn't been seen, and then with stuff that hasn't been checked in a while.
    randoms.merge(Domain.select(:id).where(checked_at: nil).limit(1000).map{ |domain| domain.id })
    randoms.merge(Domain.select(:id).order(checked_at: "ASC").limit(100).map{ |domain| domain.id })

    while randoms.length < 1000 do
        randoms.add(rand(Domain.count) + 1)
    end

    randoms.each do |random|
        CheckDomainsJob.perform_later random
    end
end
