class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def self.broadcast_message(message)
    ActionCable.server.broadcast("chat_channel", {
      message: {
        objectId: message['objectId'],
        content: message['content'],
        createdAt: message['createdAt']
      },
      created_at: ApplicationController.helpers.format_datetime(message['createdAt'])
    })
  end
end