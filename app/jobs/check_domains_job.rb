class CheckDomainsJob < ApplicationJob
  queue_as :default

  def perform(domain_id)
    begin
      @domain = Domain.find(domain_id)
      
      puts "Checking: #{@domain.domain_name}"
      @domain.check_dns

      @domain.check_websites
    rescue => exception
      puts "Exception: #{exception}"
    end
  end
end
