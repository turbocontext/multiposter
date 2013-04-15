class MessageSetsController < ApplicationController

  def index
    @message_sets = current_user.message_sets.includes(:messages).order("created_at DESC").page(params[:page]).per_page(20)
  end

  def new
    ids = params[:create_message][:model_ids].split(',').map(&:to_i) if params[:create_message] && params[:create_message][:model_ids]
    @social_users = current_user.social_users.find_all_by_id(ids)
    redirect_to root_path if @social_users.length == 0
    @common_types = @social_users.map(&:provider).uniq
    @message_set = MessageSet.new
    @social_users.each do |social_user|
      @message_set.messages.build(social_user_id: social_user.id)
    end
  end

  def create
    @message_set = current_user.message_sets.create!
    params[:message_set][:messages_attributes].each_pair do |index, attributes|
      if social_user = current_user.social_users.find_by_id(attributes[:social_user_id])
        social_user.messages.create(attributes.merge(message_set_id: @message_set.id))
      end
    end
    redirect_to social_users_path
  end
end
