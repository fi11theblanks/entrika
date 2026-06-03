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
    @registration = Registration.find(params[:id])
    authorize @registration
    @old_status = @registration.status
    @registration.update(registration_params)
    @new_status = @registration.status

    # Determine if we should redirect or respond with turbo_stream
    is_from_index = request.referrer&.include?("sitesanalyzed")
    @from_dashboard = request.referrer&.include?("dashboard")

    # Set risk data so the partial has what it needs
    @risk_data = current_user.risk_score_chart_data if @from_dashboard

    respond_to do |format|
      if is_from_index && @old_status != @new_status
        # Redirect to registrations index with the new status tab active and registration ID
        format.turbo_stream do
          redirect_to sitesanalyzed_path(tab: @new_status, registration_id: @registration.id), status: :see_other
        end
        format.html { redirect_to sitesanalyzed_path(tab: @new_status, registration_id: @registration.id) }
      else
        # Stay on current page (show page or no status change), just update badge
        format.turbo_stream { render :update }
        format.html { redirect_to dashboard_path }
      end
    end
  end

  def destroy
    authorize @registration
  end

  private

  def registration_params
    params.require(:registration).permit(:status)
  end
end
