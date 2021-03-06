#-*- encoding: utf-8 -*-
require "user_info"
require "ostruct"

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

    def send(message)
      text = text_from(message)
      url = message.url || ''
      response = client.update(text + ' ' + url)
      message.update_from(OpenStruct.new(access_token: nil, id: response.id))
      response
    end

    def text_from(message)
      text = message.short_text && message.short_text.length > 0 ? message.short_text : message.text
      link_length = message.url ? message.url.length : 0
      text[0...(140 - link_length)]
    end

    def delete(message)
      client.tweet_destroy(message.uid)
    end
  end
end
