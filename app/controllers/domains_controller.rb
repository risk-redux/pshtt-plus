class DomainsController < ApplicationController
  def index
    @domains = Domain.all
  end

  def view
    @domain = Domain.find(params[:id])
  end
end
