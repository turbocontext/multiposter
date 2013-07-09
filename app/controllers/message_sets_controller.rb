class MessageSetsController < ApplicationController

  def index
    @message_sets = current_user.message_sets.includes(:messages).order("created_at DESC").page(params[:page]).per_page(20)
  end

  def new
    @social_users = current_user.social_users.checked
    if @social_users.count.zero?
      flash[:info] = "No social network account selected, check some or add them if there is none."
      redirect_to social_users_path
    end
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
        message = social_user.messages.create(attributes.merge(message_set_id: @message_set.id))
        message.send_message
      end
    end
    redirect_to new_message_set_path
  end
end
