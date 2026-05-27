class RemoveRedundantFieldsFromCompanies < ActiveRecord::Migration[8.1]
  def change
    remove_column :companies, :analysis, :text
    remove_column :companies, :summary, :text
    remove_column :companies, :flags, :text
  end
end
