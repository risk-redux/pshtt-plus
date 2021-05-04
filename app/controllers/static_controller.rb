class StaticController < ApplicationController
  def index
    @data = [
      { label: "Live", value: Domain.where(is_live: true).count },
      { label: "Dead", value: Domain.where(is_live: false).count }
    ]

    respond_to do |format|
      format.html
      format.json { render json: JSON.pretty_generate(@data) }
    end
  end

  def about
  end
end
