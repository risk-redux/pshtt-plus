class ReportsController < ApplicationController
  def index
    @reports = Report.order(created_at: "DESC").limit(10)
  end
end
