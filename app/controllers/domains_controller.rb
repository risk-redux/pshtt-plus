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

  def load
    if request.get?
      # Just load the view.
    elsif request.post?
      if params[:file]
        @queued_targets = parse_file params[:file]
      end
    end
  end

  private

  def parse_file(file)
    targets = File.open file
    queued_targets = []

    targets.readlines.each do |target|
      d = Domain.find_or_create_by(domain_name: target.chomp)

      CheckDomainsJob.perform_later d.id

      queued_targets.push d
    end

    return queued_targets
  end

  def domain_queue_params
    # Todo: Strong parameter validation.
    puts "\n\n\n", params, "\n\n\n"
  end
end
