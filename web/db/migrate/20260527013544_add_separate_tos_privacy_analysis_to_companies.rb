class AddSeparateTosPrivacyAnalysisToCompanies < ActiveRecord::Migration[8.1]
  def change
    add_column :companies, :tos_summary, :text
    add_column :companies, :privacy_summary, :text
    add_column :companies, :tos_analysis, :text
    add_column :companies, :privacy_analysis, :text
    add_column :companies, :tos_risk_score, :float
    add_column :companies, :privacy_risk_score, :float
  end
end
