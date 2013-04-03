class MessagesController < ApplicationController
  def index
    @messages = current_user.messages.order("created_at DESC")
  end
end
