class ChangeRiskValuePrecision < ActiveRecord::Migration[8.1]
  def change
    change_column :companies, :risk_value, :decimal, precision: 4, scale: 2
  end
end
