class AddWarningsToCompanies < ActiveRecord::Migration[8.1]
  def change
    add_column :companies, :general_warning, :text
    add_column :companies, :data_warning, :text
    add_column :companies, :tracking_warning, :text
  end
end
