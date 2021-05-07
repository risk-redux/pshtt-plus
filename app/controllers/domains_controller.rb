class DomainsController < ApplicationController
  def index
    @domains = Domain.all

    respond_to do |format|
      format.html {}
      format.json { render json: DomainTable.new(view_context) }
    end
  end

  def view
    @domain = Domain.find(params[:id])
  end

  def queue
    @domain = Domain.find(params[:id])

    if @domain.checked_at < (DateTime.now - 1.day)
      CheckDomainsJob.perform_later params[:id]

      redirect_to @domain
    else
      redirect_to @domain
    end
  end

  private

  def domain_queue_params
    puts "\n\n\n", params, "\n\n\n"
  end
end
