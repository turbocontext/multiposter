class MessageSetsController < ApplicationController
  def new
    ids = params[:model_ids].split(',').map(&:to_i) if params[:model_ids]
    @social_users = current_user.social_users.find_all_by_id(ids)
    redirect_to root_path if @social_users.length == 0
  end
end