class MessagesController < ApplicationController
  def index
    if request.path == root_path
      redirect_to messages_path and return
    end
    
    @messages = Back4App.get_messages
    Rails.logger.info "Retrieved messages: #{@messages.inspect}"
  rescue => e
    Rails.logger.error "Error fetching messages: #{e.message}"
    @messages = []
    flash.now[:alert] = "Failed to load messages. Please try again later."
  end

  def create
    Rails.logger.info "Received message: #{message_params.inspect}"
    response = Back4App.create_message(message_params[:content])
    Rails.logger.info "Back4App response: #{response.inspect}"
    if response.success?
      ActionCable.server.broadcast('chat_channel', { message: message_params[:content] })
      render json: { success: true }, status: :created
    else
      render json: { error: 'Failed to save message', details: response.body }, status: :unprocessable_entity
    end
  rescue => e
    Rails.logger.error "Error creating message: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    render json: { error: 'An unexpected error occurred' }, status: :internal_server_error
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end