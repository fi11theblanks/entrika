class Api::V1::CompaniesController < ApplicationController
  def show
    @company = Company.find(params[:id])
    authorize @company
    render json: @company
  end

  def search
    skip_authorization
    domain = params[:domain]
    @company = Company.where("url ILIKE ?", "%#{domain}%").first

    if @company
      registered = Registration.exists?(company_id: @company.id, user_id: 1)
      render json: @company
    else
      render json: { error: "Company not found" }, status: :not_found
    end
  end

  def create
    @company = Company.new(company_params)
    if @company.save
      redirect_to company_path
    else
      render companies_path
    end
  end

  private

  def company_params
    params.require(:company).permit(:name, :url)
  end
end
