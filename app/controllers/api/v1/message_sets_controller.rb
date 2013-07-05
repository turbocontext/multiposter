module Api
  module V1
    class MessageSetsController < ApplicationController
      def create
        # @message_set = current_user.message_sets.create!
        # params[:message_set][:messages_attributes].each_pair do |index, attributes|
        #   if social_user = current_user.social_users.find_by_id(attributes[:social_user_id])
        #     social_user.messages.create(attributes.merge(message_set_id: @message_set.id))
        #   end
        # end
        #   redirect_to social_users_path
        # end
      end
    end
  end
end
