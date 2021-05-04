class ReportsController < ApplicationController
  def index
    @reports = Report.order(created_at: "DESC").limit(10)
  end

  def download
    @report = Report.find(params[:id])

    send_data @report.content_blob, filename: "#{@report.created_at.strftime("%F")}.csv"
  end
end
