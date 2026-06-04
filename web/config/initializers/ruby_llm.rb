RubyLLM.configure do |config|
  config.openai_api_key = ENV.fetch("GITHUB_TOKEN")
  config.openai_api_base = "https://models.inference.ai.azure.com"
  # config.gemini_api_key = ENV.fetch["GEMINI_API_KEY"]
  # config.gemini_api_base = "https://generativelanguage.googleapis.com"
  # config.anthropic_api_key = ENV.fetch("ANTHROPIC_TOKEN")
  # config.anthropic_api_base = "https://api.anthropic.com/v1/messages"
end
