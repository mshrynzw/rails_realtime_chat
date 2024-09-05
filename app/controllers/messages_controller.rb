class MessagesController < ApplicationController
  before_action :require_login

  def index
    @messages = Back4App.get_messages
    @messages = @messages.sort_by { |m| m['createdAt'] }.reverse
  rescue => e
    @messages = []
    flash.now[:alert] = "メッセージの読み込みに失敗しました。エラー: #{e.message}"
    Rails.logger.error "Error in MessagesController#index: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
  end

  def create
    @message = Back4App.create_message(message_params[:content])
    
    if @message
      ChatChannel.broadcast_message(@message)
      respond_to do |format|
        format.turbo_stream { head :ok }  # 空のレスポンスを返す
        format.html { redirect_to messages_path }
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.prepend("messages-container", partial: "messages/error") }
        format.html { redirect_to messages_path, alert: "メッセージの送信に失敗しました。" }
      end
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end