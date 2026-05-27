class SeedCompanyAnalysis < ActiveRecord::Migration[8.1]
  def up
    # data seeding moved to db/seeds.rb
  end

  def down
    Company.update_all(
      risk_score: nil, tos_summary: nil, privacy_summary: nil,
      tos_analysis: nil, privacy_analysis: nil, summary: nil, analysis: nil
    )
  end
end
