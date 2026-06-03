class AddExtAnalysisToCompanies < ActiveRecord::Migration[8.1]
  def change
    add_column :companies, :ext_tos_analysis, :text
    add_column :companies, :ext_privacy_analysis, :text
  end
end
