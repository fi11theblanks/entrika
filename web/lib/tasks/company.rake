require_relative "../company_analysis_data"

namespace :company do
  desc "Apply pre-generated AI analysis to all companies (no LLM calls)"
  task seed_analysis: :environment do
    COMPANY_ANALYSIS_DATA.each do |name, data|
      company = Company.find_by(name: name)
      if company
        company.update!(data.merge(
          summary: "Terms of Service Summary:\n#{data[:tos_summary]}\n\nPrivacy Policy Summary:\n#{data[:privacy_summary]}",
          analysis: "Terms of Service Analysis:\n#{data[:tos_analysis]}\n\nPrivacy Policy Analysis:\n#{data[:privacy_analysis]}"
        ))
        puts "✓ #{name}"
      else
        puts "✗ #{name} not found"
      end
    end
  end
end
