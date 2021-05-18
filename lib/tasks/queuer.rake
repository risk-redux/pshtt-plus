desc 'Queue up some jobs!'
task :queuer => :environment do
    targets = Set.new

    total = Domain.count
    portion = 0.25
    chunk = (total * portion).ceil
    
    puts "Queuing up #{chunk} jobs!"

    news = Domain.select(:id).where(checked_at: nil).map{ |domain| domain.id }
    olds = Domain.select(:id).order(checked_at: "ASC").limit(chunk).map{ |domain| domain.id }

    # Seed with anything that hasn't been seen.
    targets.merge(news)

    if targets.length < chunk
        targets.merge(olds)
    end

    targets.each do |target|
        CheckDomainsJob.perform_later target
    end
end
