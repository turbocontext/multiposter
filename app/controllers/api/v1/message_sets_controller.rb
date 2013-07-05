module Api
  module V1
    class MessageSetsController < ApplicationController
      skip_before_filter :authenticate_user!
      before_filter :restrict_access

      def create
        @message_set = @user.message_sets.create!
        @user.social_users.checked.each do |social_user|
          social_user.messages.create(params[:message].merge(message_set_id: @message_set.id))
        end
        render nothing: true
      end

    private
      def restrict_access
        @user = User.where(api_key: params[:api_key]).first
        head :unauthorized unless @user
      end
    end
  end
end
