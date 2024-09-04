class MessagesController < ApplicationController
  def index
    @messages = Back4App.get_messages
    Rails.logger.info "Received messages: #{@messages.inspect}"
  rescue => e
    Rails.logger.error "Back4App API Error: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    @messages = []
  end

  def create
    response = Back4App.create_message(params[:content])
    if response.success?
      redirect_to messages_path, notice: 'Message was successfully created.'
    else
      redirect_to messages_path, alert: 'Failed to save message'
    end
  rescue => e
    Rails.logger.error "Back4App API Error: #{e.message}"
    redirect_to messages_path, alert: 'Failed to save message'
  end
end