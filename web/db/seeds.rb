require_relative "../lib/company_analysis_data"

User.find_or_create_by!(email: "test@example.com") do |user|
  user.password = "password"
  user.password_confirmation = "password"
  user.username = "testuser"
end

TosScraper.scrape_all

COMPANY_ANALYSIS_DATA.each do |name, data|
  company = Company.find_by(name: name)
  next unless company
  company.update!(data.merge(
    summary: "Terms of Service Summary:\n#{data[:tos_summary]}\n\nPrivacy Policy Summary:\n#{data[:privacy_summary]}",
    analysis: "Terms of Service Analysis:\n#{data[:tos_analysis]}\n\nPrivacy Policy Analysis:\n#{data[:privacy_analysis]}"
  ))
end
