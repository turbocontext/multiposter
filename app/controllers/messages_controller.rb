class MessagesController < ApplicationController
  def destroy
    @message = Message.find(params[:id])
    @message.delete
    @message.destroy
    redirect_to :back
  rescue ActionController::RedirectBackError
    redirect_to root_path
  end
end
