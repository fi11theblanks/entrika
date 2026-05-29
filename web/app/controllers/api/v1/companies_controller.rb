class Api::V1::CompaniesController < Api::V1::BaseController
  # skip_before_action :verify_authenticity_token
  # skip_before_action :authenticate_user!, only: %i[show create search]

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
      render json: @company.as_json.merge(registered: registered)
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
