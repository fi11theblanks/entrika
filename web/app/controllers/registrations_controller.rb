class RegistrationsController < ApplicationController
  def index
    @registrations = policy_scope(Registration)
    @statuses = @registrations.pluck(:status).uniq
    if params[:site].present?
      @registrations = Registration.search(params[:site])
    else
      @registrations = Registration.all
    end
    # query function might be needed at some point
  end

  def show
    @registration = Registration.find(params[:id])
    authorize @registration
  end

  def new
    @registration = Registration.new
    authorize @registration
  end

  def create
    authorize @registration
  end

  def edit
    authorize @registration
  end

  def update
    authorize @registration
  end

  def destroy
    authorize @registration
  end
end
