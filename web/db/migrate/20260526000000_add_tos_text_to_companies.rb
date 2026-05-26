class AddTosTextToCompanies < ActiveRecord::Migration[8.1]
  def change
    add_column :companies, :tos_text, :text
  end
end
