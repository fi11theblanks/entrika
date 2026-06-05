class AddRiskValueToCompanies < ActiveRecord::Migration[8.1]
  def change
    add_column :companies, :risk_value, :decimal
  end
end
