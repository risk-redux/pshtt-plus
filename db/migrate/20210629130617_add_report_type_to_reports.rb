class AddReportTypeToReports < ActiveRecord::Migration[6.1]
  def change
    add_column :reports, :report_type, :text

    Report.reset_column_information

    Report.all.each do |r|
      r.update_attribute :report_type, 'domains'
    end
  end
end
