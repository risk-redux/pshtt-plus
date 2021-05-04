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

  private
end
