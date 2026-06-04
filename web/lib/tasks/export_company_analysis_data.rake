# lib/tasks/export_company_analysis_data.rake

namespace :company do
  desc "Export company data back to company_analysis_data.rb"
  task export: :environment do
    json_file = "#{__dir__}/company_info.json"
    company_info = {}

    Company.order(:name).find_each do |company|
      company_info[company.name] = {
        risk_score: company.risk_score,
        url: company.url,
        tos_url: company.tos_url,
        privacy_url: company.privacy_url,
        tos_summary: company.tos_summary,
        privacy_summary: company.privacy_summary,
        tos_analysis: company.tos_analysis,
        privacy_analysis: company.privacy_analysis,
        general_warning: company.general_warning,
        data_warning: company.data_warning,
        tracking_warning: company.tracking_warning
      }
    end
    File.open(json_file, "wb") do |file|
      file.write(JSON.generate(company_info))
    end
  end
end
