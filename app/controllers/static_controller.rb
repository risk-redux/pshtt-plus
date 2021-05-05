class StaticController < ApplicationController
  def index

    @data = Set.new

    @data << { domain_data: [
      { label: "Live", value: Domain.where(is_live: true).count },
      { label: "Dead", value: Domain.where(is_live: false).count }
    ] }

    @data << { website_data: [
      { label: "Live", value: Website.where(is_live: true).count },
      { label: "Dead", value: Website.where(is_live: false).count }
    ] }

    respond_to do |format|
      format.html
      format.json { render json: JSON.pretty_generate(@data.as_json) }
    end
  end

  def about
  end
end
