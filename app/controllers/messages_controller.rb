class MessagesController < ApplicationController
  def destroy
    @message = Message.find(params[:id])
    @message_set = @message.message_set
    @message.delete_message
    @message.destroy
    @message_set.destroy if @message_set.messages.count == 0
    redirect_to :back
  rescue ActionController::RedirectBackError
    redirect_to root_path
  end
end
