class CreateRegistrations < ActiveRecord::Migration[8.1]
  def change
    create_table :registrations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :company, null: false, foreign_key: true
      t.string :status

      t.timestamps
    end
  end
end
