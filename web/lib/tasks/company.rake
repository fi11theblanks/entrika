require_relative "../company_analysis_data"

namespace :company do
  desc "Apply pre-generated AI analysis to all companies (no LLM calls)"
  task create: :environment do
      puts "Applying AI analysis to companies..."
    Company.destroy_all
    COMPANY_ANALYSIS_DATA.each do |name, data|
      company = Company.new(name: name)
      company.update!(data)
        #  "Terms of Service Summary:\n#{data[:tos_summary]}\n\nPrivacy Policy Summary:\n#{data[:privacy_summary]}",
        # "Terms of Service Analysis:\n#{data[:tos_analysis]}\n\nPrivacy Policy Analysis:\n#{data[:privacy_analysis]}"
    end
  end
end
