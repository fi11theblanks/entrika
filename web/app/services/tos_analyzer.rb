module TosAnalyzer
  SCORES = { "low" => 1.0, "moderate" => 2.0, "high" => 3.0 }.freeze

  def self.analyze_all
    Company.where.not(tos_url: nil).find_each do |company|
      puts "Analyzing #{company.name}..."
      Summary.new(company).analyze
      Analysis.new(company).analyze
      RiskScore.new(company).analyze
      puts "✓ #{company.name} done"
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
      result = ask(SCHEMA, "Summarize each document in 3 sentences for a non-technical user.\n\nTerms of Service: #{@company.tos_url}\nPrivacy Policy: #{@company.privacy_url}")
      combined = "Terms of Service Summary:\n#{result["tos_summary"]}\n\nPrivacy Policy Summary:\n#{result["privacy_summary"]}"
      @company.update!(tos_summary: result["tos_summary"], privacy_summary: result["privacy_summary"], summary: combined)
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
      Analyze each document separately. For each, cover:
      - What the company can do: translate each point into a concrete real-world scenario starting with "This means they can..."
      - Top 3 concerning clauses: paraphrase each, explain why it matters, give a real-world example. Skip if no significant concerns.
      - Third-party data sharing: what is shared, with whom, and a realistic risk scenario for the user.
      - Privacy advocate verdict: one sentence.
    TEXT

    def analyze
      result = ask(SCHEMA, "#{INSTRUCTIONS}\n\nTerms of Service: #{@company.tos_url}\nPrivacy Policy: #{@company.privacy_url}")
      combined = "Terms of Service Analysis:\n#{result["tos_analysis"]}\n\nPrivacy Policy Analysis:\n#{result["privacy_analysis"]}"
      @company.update!(tos_analysis: result["tos_analysis"], privacy_analysis: result["privacy_analysis"], analysis: combined)
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
      @company.update!(risk_score: SCORES[result["risk_score"]&.downcase])
    end
  end
end
