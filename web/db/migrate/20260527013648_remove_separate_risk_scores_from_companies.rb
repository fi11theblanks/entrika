class RemoveSeparateRiskScoresFromCompanies < ActiveRecord::Migration[8.1]
  def change
    remove_column :companies, :tos_risk_score, :float
    remove_column :companies, :privacy_risk_score, :float
  end
end
