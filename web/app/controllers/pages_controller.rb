class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
  end

  def dashboard
    @registrations = policy_scope(Registration)
    @sorted_registrations = @registrations.order(updated_at: :desc).first(3)
    @risk_data = current_user.risk_score_chart_data
    @high_risk_registrations = current_user.high_risk_registrations
  end
end
