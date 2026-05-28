class Api::V1::RegistrationsController < Api::V1::BaseController
  skip_before_action :verify_authenticity_token

  def create
    # skip_authorization
    user = User.first
    @registration = Registration.new(
      company_id: params[:company_id],
      user: user,
      status: "active"
    )
    if @registration.save
      render json: @registration, status: :created
    else
      render json: { error: @registration.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
