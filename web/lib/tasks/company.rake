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

  desc "Update existing hashes with new info"
  task update: :environment do
    json_file = "#{__dir__}/company_info.json"
    json = File.read(json_file)
    company_info = JSON.parse(json)
    company_info.each do |name, info|
      company = Company.find_or_create_by(name: name)
      puts "Created: #{name}"
      company.update(info)
    end
  end
end
