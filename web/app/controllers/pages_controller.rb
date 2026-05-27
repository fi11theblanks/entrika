class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
  end

  def dashboard
    @registrations = policy_scope(Registration)
    @sorted_registrations = @registrations.order(updated_at: :desc).first(3)
  end
end
