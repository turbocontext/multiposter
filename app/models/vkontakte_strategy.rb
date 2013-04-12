#-*- encoding: utf-8 -*-
require 'user_info'
require "ostruct"
module VkontakteStrategy
  class User
    attr_accessor :auth, :info
    def initialize(auth)
      @auth = auth
      @info = UserInfo.new(auth)
    end

    def main_user
      info
    end

    def subusers
      []
    end
  end

  class VkontakteMessage
    attr_accessor :user
    def initialize(user)
      @user = user
    end

    def send(message)
      text = message.text
      link = message.url
      fb_user = FbGraph::User.me(user.access_token)
      if link.blank?
        response = fb_user.feed!(message: text)
      else
        response = fb_user.link!(message: text, link: link)
      end

      message.update_from(OpenStruct.new(id: response.identifier, access_token: response.access_token))
      response
    end
  end

end