class CompaniesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index, :show ]
  def index
    @companies = policy_scope(Company)
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
