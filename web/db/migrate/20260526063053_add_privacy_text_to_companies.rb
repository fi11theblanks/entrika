class AddPrivacyTextToCompanies < ActiveRecord::Migration[8.1]
  def change
    add_column :companies, :privacy_text, :text
  end
end
