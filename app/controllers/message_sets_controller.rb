class MessageSetsController < ApplicationController
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
    params[:message_set][:messages_attributes].each_pair do |index, attributes|
      if social_user = current_user.social_users.find_by_id(attributes[:social_user_id])
        social_user.messages.create(attributes)
      end
    end
    @message_set = current_user.message_sets.create!
  end
end
