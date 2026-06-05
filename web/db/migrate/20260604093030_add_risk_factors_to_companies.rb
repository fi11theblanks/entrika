class AddRiskFactorsToCompanies < ActiveRecord::Migration[8.1]
  def change
    add_column :companies, :risk_factors, :jsonb
  end
end
