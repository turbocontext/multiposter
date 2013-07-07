module Api
  module V1
    class MessagesController < ApplicationController
      skip_before_filter :authenticate_user!
    end
  end
end
