class AddTosUrlAndPrivacyUrlToCompanies < ActiveRecord::Migration[8.1]
  def change
    add_column :companies, :tos_url, :string
    add_column :companies, :privacy_url, :string
  end
end
