class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :registrations
  has_many :companies, through: :registrations
  validates :username, presence: true, uniqueness: true
  validates :password, presence: true

  RISK_LABELS = { 1 => "Low", 2 => "Medium", 3 => "High" }
  RISK_COLORS = { "Low" => "#2ecc71", "Medium" => "#f39c12", "High" => "#e74c3c" }

  def risk_score_chart_data
    RISK_LABELS.sort_by { |k, _| k }.filter_map do |k, label|
      count = registered_sites.where(risk_score: k).count
      [label, count]
    end.to_h
  end

  def registered_risk_score
    return 0 unless registered_companies.any?

    score = (Company.where(id: registered_companies).pluck(:risk_score).sum / registered_companies.count).round(2)

    case score
    when 0.0..1.5 then "Low Risk"
    when 1.5..2.5 then "Medium Risk"
    when 2.5..3.0 then "High Risk"
    else "Unknown"
    end
  end

  def registered_companies
    registrations.where(status: 'registered').pluck(:company_id)
  end

  def registered_sites
    Company.where(id: registered_companies)
  end
end
