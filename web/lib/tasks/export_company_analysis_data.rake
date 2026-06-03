# lib/tasks/export_company_analysis_data.rake

namespace :company do
  desc "Export company data back to company_analysis_data.rb"
  task export: :environment do
    puts "CompanyAnalysisData = {"

    Company.order(:name).find_each do |company|
      puts <<~RUBY
        "#{company.name}" => {
          risk_score: #{company.risk_score.inspect},
          url: #{company.url.inspect},
          tos_url: #{company.tos_url.inspect},
          privacy_url: #{company.privacy_url.inspect},
          tos_summary: #{company.tos_summary.inspect},
          privacy_summary: #{company.privacy_summary.inspect},
          tos_analysis: #{company.tos_analysis.inspect},
          privacy_analysis: #{company.privacy_analysis.inspect},
          general_warning: #{company.general_warning.inspect},
          data_warning: #{company.data_warning.inspect},
          tracking_warning: #{company.tracking_warning.inspect}
        },
      RUBY
    end

    puts "}"
  end
end
