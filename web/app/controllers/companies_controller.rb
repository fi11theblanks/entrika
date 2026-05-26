class CompaniesController < ApplicationController
  def index
    @companies = Company.all
    authorize @company
    # query function might be needed at some point
  end

  def show
    @company = Company.find(params[:id])
    authorize @company
  end

  def edit
    @company = Company
    authorize @company
  end

  def update
    authorize @company
  end
end
