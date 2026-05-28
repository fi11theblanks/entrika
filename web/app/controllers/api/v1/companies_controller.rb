class Api::V1::CompaniesController < ApplicationController
  def show
    @company = Company.find(params[:id])
    authorize @company
    render json: @company
  end

  def search
    domain = params[:domain]
    @company = Company.where("url ILIKE ?", "%#{domain}%").first

    if @company
      render json: @company
    else
      render json: { error: "Company not found" }, status: :not_found
    end
  end
end
