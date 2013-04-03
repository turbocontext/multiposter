#-*- encoding: utf-8 -*-
require "user_info"
module TwitterStrategy
  class User
    def initialize(auth)
      @auth = auth
      @info = UserInfo.new(auth)
    end

    def main_user
      @info
    end

    def subusers
      []
    end
  end

  class TwitterMessage
    attr_accessor :user
    def initialize(user)
      @user = user
    end

    def client
      @client ||= Twitter::Client.new(oauth_token: user.access_token, oauth_token_secret: user.secret_token, consumer_key: ENV['twitter_id'], consumer_secret: ENV['twitter_secret'])
    end

    def send_message(message)
      response = client.update(message.text + '' + message.url)
      message.update_from(response)
      response
    end
  end
end
