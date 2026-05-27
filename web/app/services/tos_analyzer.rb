class TosAnalyzer
  SYSTEM_PROMPT = <<~PROMPT
    You are a privacy and legal analyst. Analyze Terms of Service and Privacy Policy documents.
    Be direct, plain-spoken, and useful to a non-technical user. Never use em dashes.
  PROMPT

  USER_PROMPT = <<~PROMPT
    Analyze the following Terms of Service and Privacy Policy.

    Summary: 3 sentences explaining the key points to a non-technical user.

    Analysis:
    - What the company can do: for each point, translate it into a concrete real-world scenario starting with "This means they can..." rather than stating it as a legal right.
    - Top 3 concerning clauses: paraphrase each clause, explain why it matters, and give a real-world example of how it could affect a regular user. Skip if there are no significant concerns.
    - Third-party data sharing: what specifically is shared, with whom, and describe a realistic scenario where this creates risk for the user.
    - Privacy advocate verdict: one sentence.

    Risk score: Low, Moderate, or High — one word only.

    Terms of Service:
    %{tos_text}

    Privacy Policy:
    %{privacy_text}
  PROMPT

  RESPONSE_SCHEMA = {
    type: "object",
    properties: {
      summary: { type: "string" },
      analysis: { type: "string" },
      risk_score: { type: "string", enum: ["Low", "Moderate", "High"] }
    },
    required: ["summary", "analysis", "risk_score"],
    additionalProperties: false
  }.freeze

  RISK_SCORES = { "low" => 1.0, "moderate" => 2.0, "high" => 3.0 }.freeze
  FETCH_HEADERS = { "User-Agent" => "Mozilla/5.0 (compatible; Entrika/1.0)" }.freeze

  def self.analyze_all
    Company.where.not(tos_url: nil).find_each do |company|
      puts "Analyzing #{company.name}..."
      new(company).analyze
      puts "✓ #{company.name} done"
    rescue => e
      puts "✗ #{company.name} failed: #{e.message}"
    end
  end

  def initialize(company)
    @company = company
  end

  def analyze
    tos_text = fetch_text(@company.tos_url)
    privacy_text = fetch_text(@company.privacy_url)

    prompt = USER_PROMPT % {
      tos_text: tos_text.truncate(20_000),
      privacy_text: privacy_text.truncate(10_000)
    }

    chat = RubyLLM.chat(model: "gpt-4o")
    chat.with_instructions(SYSTEM_PROMPT).with_schema(RESPONSE_SCHEMA)
    result = chat.ask(prompt).content

    @company.update!(
      summary: result["summary"],
      analysis: result["analysis"],
      risk_score: RISK_SCORES[result["risk_score"]&.downcase]
    )
  end

  private

  def fetch_text(url)
    return "" if url.blank?
    response = HTTParty.get(url, headers: FETCH_HEADERS, timeout: 15)
    return "" unless response.success?
    doc = Nokogiri::HTML(response.body)
    doc.css("script, style, nav, header, footer").remove
    doc.css("body").text.squish
  end
end
