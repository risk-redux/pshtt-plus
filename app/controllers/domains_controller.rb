class DomainsController < ApplicationController
  def index
    @domains = Domain.all

    respond_to do |format|
      format.html {}
      format.json { render json: DomainTable.new(view_context) }
      format.csv { send_data generate_csv(@domains), filename: "#{DateTime.now.strftime('%F')}.csv" }
    end
  end

  def view
    @domain = Domain.find(params[:id])
  end

  private

  def generate_csv(domains)
    headers = ["domain_name", "is_live", "live_websites", "is_behaving", "checked_at"]

    CSV.generate(headers: true) do |csv| 
      domains.each do |domain|
        csv << CSV::Row.new(headers, [
          domain.domain_name,
          domain.is_live,
          domain.websites.where(is_live: true).count,
          domain.is_behaving?,
          domain.checked_at
        ])
      end
    end
  end
end
