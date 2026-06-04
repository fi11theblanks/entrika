class AlternativeCompaniesService
  SCHEMA = {
    type: "object",
    properties: {
      company_ids: {
        type: "array",
        items: { type: "integer" },
        maxItems: 3
      }
    },
    required: ["company_ids"],
    additionalProperties: false
  }.freeze

  def initialize(company)
    @company = company
  end

  def call
    candidates = Company.where.not(id: @company.id)
                        .where("risk_score < ?", @company.risk_score)
                        .select(:id, :name)

    return [] if candidates.empty?

    prompt = <<~PROMPT
      I have a company called "#{@company.name}" (URL: #{@company.url}).

      From the following list, return the IDs of up to 3 companies that are realistic substitutes for #{@company.name}. Return an empty array if none qualify.
      Return an empty array if none are similar.

      #{candidates.map { |c| "ID #{c.id}: #{c.name}" }.join("\n")}
    PROMPT

    chat = RubyLLM.chat(model: "gpt-4o-mini")
    result = chat.with_instructions(
      "You classify internet companies according to their primary user use case so that companies in the same category represent realistic substitutes and competitors.
      For example:
        Instagram ↔ TikTok ↔ Snapchat: Social Media
        WhatsApp ↔ Telegram ↔ Signal: Messaging
        Netflix ↔ Disney+ ↔ Hulu: Video/Streaming
        LinkedIn ↔ Indeed ↔ Glassdoor: Professional Networking / Job Platform
        Amazon ↔ Temu ↔ eBay: E-commerce marketplace"
    )
                 .with_schema(SCHEMA)
                 .ask(prompt)
                 .content

    ids = result["company_ids"] || []
    Company.where(id: ids).limit(3)
  rescue StandardError => e
    Rails.logger.error("#{e.class}: #{e.message}\n#{e.backtrace.first(10).join("\n")}")
    []
  end
end
