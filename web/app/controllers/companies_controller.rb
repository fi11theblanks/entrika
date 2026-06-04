class CompaniesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]
  def index
    @companies = policy_scope(Company)
    if params[:query].present?
      @companies = Company.search(params[:query])
    else
      @companies = Company.all
    end
    # query function might be needed at some point
  end

  def show
    @company = Company.find(params[:id])
    authorize @company
    @message = Message.new
    @registration = current_user&.registrations&.find_by(company: @company)
    if @company.risk_score.present?
      @alternatives = Company.order(risk_score: :asc).first(3)
      # @alternatives = AlternativeCompaniesService.new(@company).call
    else
      @alternatives = []
    end
  end

  def edit
    @company = Company
    authorize @company
  end

  def update
    authorize @company
  end
end
