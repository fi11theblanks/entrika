class ComputeAlternativesJob < ApplicationJob
  queue_as :default

  def perform(company_id)
    company = Company.find(company_id)
    alternatives = AlternativeCompaniesService.new(company).call
    Rails.cache.write("alternatives/#{company_id}", alternatives.map(&:id), expires_in: 1.day)
  end
end
