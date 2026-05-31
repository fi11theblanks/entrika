class Api::V1::CompaniesController < Api::V1::BaseController
  skip_before_action :authenticate_user!, only: %w[search analyze], raise: false

  def show
    @company = Company.find(params[:id])
    authorize @company
    render json: @company
  end

  def search
    skip_authorization
    domain = params[:domain].split(".").last(2).join(".")
    @company = Company.where("url ILIKE ?", "%#{domain}%").first

    if @company
      registered = Registration.exists?(company_id: @company.id, user_id: 1)
      render json: @company.as_json(methods: :risk_label).merge(registered: registered)
    else
      render json: { error: "Company not found" }, status: :not_found
    end
  end

  def analyze
    skip_authorization
    page_url = params[:url]

    return render json: { error: "NO URL provided" }, status: :bad_request unless page_url

    domain = URI.parse(page_url).hostname.gsub(/^www\./, "").split(".").last(2).first.capitalize

    company = TosScraper.scrape_one(page_url, domain)
    TosAnalyzer.analyze_company(company)

    render json: company.as_json(methos: :risk_label)
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
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
