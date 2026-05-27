class Company < ApplicationRecord
  has_many :registrations, dependent: :destroy
  has_many :users, through: :registrations
  #validates :url, presence: true
  validates :name, presence: true


  def risk_label
    case risk_score
    when 1.0 then "Low Risk"
    when 2.0 then "Medium Risk"
    when 3.0 then "High Risk"
    else "Unknown"
    end
  end
end
