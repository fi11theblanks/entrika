class CreateCompanies < ActiveRecord::Migration[8.1]
  def change
    create_table :companies do |t|
      t.string :url
      t.string :name
      t.datetime :last_checked
      t.float :risk_score
      t.text :analysis
      t.text :summary
      t.text :flags

      t.timestamps
    end
  end
end
