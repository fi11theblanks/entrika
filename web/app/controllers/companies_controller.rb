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
    Rails.logger.info "X-Sec-Purpose=#{request.headers['X-Sec-Purpose']}"
    Rails.logger.info "Purpose=#{request.headers['Purpose']}"
    @company = Company.find(params[:id])
    authorize @company
    @message = Message.new
    @registration = current_user&.registrations&.find_by(company: @company)
    if @company.risk_score.present?
      Rails.logger.info "[CONTROLLER] PID=#{Process.pid} CACHE=#{Rails.cache.class}"
      cached_ids = Rails.cache.read("alternatives/#{@company.id}")
      if cached_ids == :none
        @alternatives = []
      elsif cached_ids&.any?
        @alternatives = Company.where(id: cached_ids)
      else
        @alternatives = Company.order(risk_score: :asc).first(3)
        ComputeAlternativesJob.perform_later(@company.id)
      end
    else
      @alternatives = Company.order(risk_score: :asc).first(3)
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
