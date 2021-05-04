desc 'Generate a report!'
task :reporter => :environment do
  puts "Generating a report!"

  begin
    headers = ["domain_name", "is_live", "live_websites", "is_behaving", "checked_at"]

    report = CSV.generate(headers: true) do |csv| 
      csv << headers 
      
      Domain.all.each do |domain|
        csv << CSV::Row.new(headers, [
          domain.domain_name,
          domain.is_live,
          domain.websites.where(is_live: true).count,
          domain.is_behaving?,
          domain.checked_at
        ])
      end
    end

    report = Report.create(content_blob: report)
    report.save
  rescue => exception
    puts "Exception:", exception
  end
end
