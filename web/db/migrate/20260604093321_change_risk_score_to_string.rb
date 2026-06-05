class ChangeRiskScoreToString < ActiveRecord::Migration[8.1]
  def change
    change_column :companies, :risk_score, :string
  end
end
