class MessagesController < ApplicationController
  def index
    @message_sets = current_user.message_sets.includes(:messages).order("created_at DESC")
  end
end
