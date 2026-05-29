require_relative "../company_analysis_data"

namespace :company do
  desc "Apply pre-generated AI analysis to all companies (no LLM calls)"
  task create: :environment do
      puts "Applying AI analysis to companies..."
    Message.delete_all
    Registration.delete_all
    Company.delete_all
    CompanyAnalysisData.each do |name, data|
      Company.create!(data.merge(name: name))
      puts "Created: #{name}"
    end
  end
end
