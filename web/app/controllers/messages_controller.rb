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

    # removed the following 2 lines and added them to job:
    # @ruby_llm_chat = RubyLLM.chat(model: "gpt-4o")
    # build_conversation_history

    if @message.save
      # show instant placeholder for user while AI moves to background
      @assistant_message = Message.create(
        role: 'assistant',
        content: '<i class="fa-solid fa-ellipsis fa-beat-fade"></i>',
        registration: @registration
      )
      # move llm message creation logic to background, in message_create_job.rb
      # def perform takes two args: (user_message, assistant_message)
      MessageCreateJob.perform_later(@message, @assistant_message)
      respond_to do |format|
        format.html { redirect_to company_path(@company) }
        format.turbo_stream
      end
    else
      render "companies/show", status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
