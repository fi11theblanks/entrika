class MessagesController < ApplicationController
  def create
    @company = Company.find(params[:company_id])
    @registration = Registration.find_or_create_by(user: current_user, company: @company)
    @message = Message.new(message_params)
    @message.role = "user"
    @message.registration = @registration
    authorize @message

    # check if company user asks about is @company and/or in our db:
    # user_message_text = @message.content.downcase
    # other_mentioned_company_in_db = Company.all.find do |company|
    #   user_message_text.include?(company.name.downcase) && company.id != @company.id
    # end
    # if other_mentioned_company_in_db
    #   @message.save
    #   content = "I'm specifically trained on #{@company.name}. You can search for #{other_mentioned_company_in_db.name} using the search bar on the left to find its analysis and chat with an AI Agent trained specifically on that site."
    #   @assistant_message = Message.create(role: "assistant", content: content, registration: @registration)
    #   respond_to do |format|
    #     format.html { redirect_to company_path(@company) }
    #     format.turbo_stream
    #   end
    #   return
    # end

    @ruby_llm_chat = RubyLLM.chat(model: "gpt-4o")
    build_conversation_history
    if @message.save
      assistant_content = ask_llm
      @assistant_message = Message.create(role: "assistant", content: assistant_content, registration: @registration)
      if @assistant_message.persisted?
        respond_to do |format|
          format.html { redirect_to company_path(@company) }
          format.turbo_stream
        end
      else
        render "companies/show", status: :unprocessable_entity
      end
    else
      render "companies/show", status: :unprocessable_entity
    end
  end

  private

  def ask_llm
    response = @ruby_llm_chat.with_instructions("#{instructions}\n#{company_context(@company)}").ask(@message.content)
    raise "Empty response" if response&.content.blank?

    response.content
  rescue StandardError => e
    Rails.logger.error("LLM error for company #{@company.id}: #{e.message}")
    "I'm sorry, I ran into an issue answering that. Please try again."
  end

  def instructions
    <<~PROMPT
      Persona:
      You are a privacy assessment tool used by a reputable company with a privacy review platform aiming to enable people to reclaim their digital autonomy and stop corporate data exploitation. You must act as a cybersecurity expert, and privacy analyst, knowledgeable in online privacy and privacy law, and familiar with current practices used by tech companies regarding user data collection and use.
      The user asking the questions is a privacy/security concerened individual using the internet, who is worried about if and how their personal data is collected and used by the company. They are technical enough to be concerned but not technical enough to know where to start or what to do, or to make sense of the long complex Terms of Service and Privacy Policy of the company.
      Task: Answer the user's questions, with plain language appropriate for the user's technical capability.
      Be informative, and helpful.
      You must be specific and concise in your answers.
      Give advice on ways the user can reduce their data exposure/risks and be safer online only when specifically asked
      Format: Provide answers in a professional tone with complete sentences using proper grammar.
      Format your response using markdown. Use **bold** for emphasis, and bullet points or numbered lists where appropriate.
      Never use em dashes or emoticons
      YOU MUST NOT end your messages with follow up questions
      EXPLICIT DOS AND DONTS:
      DO NOT advise the user to go to any third-party platforms
      DO NOT advise the user to go to the terms and service and/or privacy policy of a company directly
    PROMPT
  end

  def company_context(company)
    <<~COMPANY_CONTEXT
      You are only trained on #{company.name}. If the user asks about another company, tell them you specifically trained on #{company.name} and that they can search for other companies using the search bar on the left. Do NOT suggest they search for it on our site, or any third party site.
      When asked questions pertaining to the company's Terms of Service, reference #{company.tos_analysis} and be consistent with it
      When asked questions pertaining to the company's Terms of Service, reference #{company.privacy_analysis} and be consistent with it
      When asked questions regarding recent changes to the company's ToS or Privacy Policy, then reference #{company.updated_at}
      The risk score for #{company.name} is #{company.risk_score} (#{company.risk_label}).
      Only share this risk score when the user specifically asks about #{company.name}'s risk level.
      Do not provide risk scores for any other company.
    COMPANY_CONTEXT
  end

  def message_params
    params.require(:message).permit(:content)
  end

  def build_conversation_history
    # Implementation for building conversation history
    @registration.messages.each do |message|
      @ruby_llm_chat.add_message(role: message.role, content: message.content)
    end
  end
end
