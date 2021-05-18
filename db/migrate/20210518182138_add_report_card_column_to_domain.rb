class AddReportCardColumnToDomain < ActiveRecord::Migration[6.1]
  def change
    add_column :domains, :report_card, :text
  end
end
