require_relative "../lib/company_analysis_data"

User.find_or_create_by!(email: "test@example.com") do |user|
  user.password = "password"
  user.password_confirmation = "password"
  user.username = "testuser"
end
