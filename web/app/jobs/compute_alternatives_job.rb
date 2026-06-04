class ComputeAlternativesJob < ApplicationJob
  queue_as :default

  def perform(company_id)
    Rails.logger.info "[JOB] PID=#{Process.pid} CACHE=#{Rails.cache.class}"

    company = Company.find(company_id)
    Rails.logger.info "[JOB] BEFORE SERVICE"
    alternatives = AlternativeCompaniesService.new(company).call
    Rails.logger.info "[JOB] AFTER SERVICE #{alternatives.inspect}"

    value = alternatives.any? ? alternatives.map(&:id) : :none

    Rails.logger.info "[JOB] VALUE=#{value.inspect}"

    Rails.cache.write("alternatives/#{company_id}", value, expires_in: 1.day)

    Rails.logger.info "[JOB] AFTER WRITE=#{Rails.cache.read("alternatives/#{company_id}").inspect}"
  rescue StandardError => e
    Rails.logger.error "[JOB ERROR] #{e.class}: #{e.message}"
    Rails.logger.error e.backtrace.first(20).join("\n")
    raise
  end
end
