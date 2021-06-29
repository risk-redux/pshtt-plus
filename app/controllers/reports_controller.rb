class ReportsController < ApplicationController
  def index
    @domains_reports = Report.where(report_type: "domains").order(created_at: "DESC").limit(10)
    @redirects_reports = Report.where(report_type: "redirects").order(created_at: "DESC").limit(10)
  end

  def download
    @report = Report.find(params[:id])

    send_data @report.content_blob, filename: "#{@report.created_at.strftime("%F")}-#{@report.report_type}.csv"
  end
end
