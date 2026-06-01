module TosAnalyzer
  SCORES = { "low" => 1.0, "moderate" => 2.0, "high" => 3.0 }.freeze

  def self.analyze_company(company)
    puts "Analyzing #{company.name}..."
    Summary.new(company).analyze
    Analysis.new(company).analyze
    RiskScore.new(company).analyze
    puts "✓ #{company.name} done"
  rescue => e
    puts "✗ #{company.name} failed: #{e.message}"
    puts e.backtrace.first(3).join("\n")
  end

  def self.analyze_all
    Company.where.not(tos_url: nil).where(tos_summary: nil).find_each do |company|
      analyze_company(company)
    rescue => e
      puts "✗ #{company.name} failed: #{e.message}"
    end
  end

  class Base
    def initialize(company)
      @company = company
    end

    private

    def ask(schema, prompt, system: "You are a privacy analyst. Be plain-spoken and useful to a non-technical user. Never use em dashes.")
      c = RubyLLM.chat(model: "gpt-4o")
      c.with_instructions(system).with_schema(schema)
      c.ask(prompt).content
    end
  end

  class Summary < Base
    SCHEMA = {
      type: "object",
      properties: {
        tos_summary: { type: "string" },
        privacy_summary: { type: "string" }
      },
      required: ["tos_summary", "privacy_summary"],
      additionalProperties: false
    }.freeze

    def analyze
      result = ask(SCHEMA, "Summarize each document in 2 sentences for a non-technical user. Be direct and specific — name what the company actually does with your data.\n\nTerms of Service: #{@company.tos_url}\nPrivacy Policy: #{@company.privacy_url}")
      @company.update!(tos_summary: result["tos_summary"], privacy_summary: result["privacy_summary"])
    end
  end

  class Analysis < Base
    SCHEMA = {
      type: "object",
      properties: {
        tos_analysis: { type: "string" },
        privacy_analysis: { type: "string" }
      },
      required: ["tos_analysis", "privacy_analysis"],
      additionalProperties: false
    }.freeze

    INSTRUCTIONS = <<~TEXT
      Analyze the Terms of Service and Privacy Policy separately. Write in plain English for a non-technical user.

      For EACH document, output exactly this format — no extra text, no markdown headers:

      Concerning clauses:
      - [1 sentence]
      - [1 sentence]
      - [1 sentence max]

      Data sharing:
      - [1 sentence]
      - [1 sentence]
      - [1 sentence max]

      Known incidents:
      - [Year: what happened, how many users affected, exact fine amount if issued]
      - [repeat for each incident, 3 max]
      (Skip this section entirely if there are no confirmed public incidents)

      Verdict: [1 sentence]

      Rules:
      - Known incidents must be real, confirmed public facts only — no speculation.
      - Be specific: name years, fine amounts, number of affected users.
      - Maximum 3 bullets per section.
    TEXT

    def analyze
      result = ask(SCHEMA, "#{INSTRUCTIONS}\n\nTerms of Service: #{@company.tos_url}\nPrivacy Policy: #{@company.privacy_url}")
      @company.update!(tos_analysis: result["tos_analysis"], privacy_analysis: result["privacy_analysis"])
    end
  end

  class RiskScore < Base
    SCHEMA = {
      type: "object",
      properties: {
        risk_score: { type: "string", enum: ["Low", "Moderate", "High"] }
      },
      required: ["risk_score"],
      additionalProperties: false
    }.freeze

    def analyze
      result = ask(SCHEMA, "Rate the overall privacy risk as Low, Moderate, or High.\n\nTerms of Service: #{@company.tos_url}\nPrivacy Policy: #{@company.privacy_url}")
      @company.update!(risk_score: TosAnalyzer::SCORES[result["risk_score"]&.downcase])
    end
  end
end
