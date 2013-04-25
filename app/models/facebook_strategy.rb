#-*- encoding: utf-8 -*-
require 'user_info'
require "ostruct"
module FacebookStrategy
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
      user = FbGraph::User.me(info.access_token)
      user.accounts.inject([]) do |result, account|
        if account.perms.include?("CREATE_CONTENT")
          result << OpenStruct.new(
            # provider: "facebook_#{account.category.downcase}",
            provider: "facebook",
            uid:      account.identifier,
            email:    "#{account.identifier}@facebook.com",
            nickname: account.name,
            access_token: account.access_token,
            url: account.link
          )
        else
          result
        end
      end
    end
  end

  class FacebookMessage
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

    def delete(message)
      message = FbGraph::Post.new(message.uid)
      message.destroy(access_token: message.access_token)
    end
  end

end
