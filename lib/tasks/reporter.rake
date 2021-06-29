namespace "reporter" do
  desc 'Generate a domain report!'
  task :domains => :environment do
    puts "Generating a domain report!"

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

      report = Report.create(content_blob: report, report_type: "domains")
      report.save
    rescue => exception
      puts "Exception @ reporter:domains:", exception
    end
  end

  desc 'Generate a redirects report!'
  task :redirects => :environment do
    puts "Generating a redirects report!"

    begin
      headers = ["domain_name", "website_url", "http_status_code", "http_status", "redirect_url", "checked_at"]

      report = CSV.generate(headers: true) do |csv| 
        csv << headers 
        
        Website.where(is_live: true).each do |website|
          csv << CSV::Row.new(headers, [
            website.domain.domain_name,
            website.to_url,
            website.http_status_code,
            website.http_status,
            website.redirect_url,
            website.checked_at
          ])
        end
      end

      report = Report.create(content_blob: report, report_type: "redirects")
      report.save
    rescue => exception
      puts "Exception @ reporter:redirects:", exception
    end
  end
end