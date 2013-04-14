#-*- encoding: utf-8 -*-
require 'user_info'
require "ostruct"
module VkontakteStrategy
  class User
    attr_accessor :auth, :info
    def initialize(auth)
      @auth = auth
      if auth[:auth_string]
        @info = parse_auth_string
      else
        @info = UserInfo.new(auth)
      end
    end

    def main_user
      info
    end

    def subusers
      []
    end

    private

      def parse_auth_string
        uri = URI(auth[:auth_string])
        hash = Rack::Utils.parse_query(uri.fragment) if uri.fragment
        if hash && hash['access_token'] && hash['user_id']
          vk = VkontakteApi::Client.new(hash['access_token'])
          user = vk.users.get(uid: hash['user_id']).first
          nickname = user.first_name + ' ' + user.last_name
          return OpenStruct.new({
            provider: 'vkontakte',
            uid: hash['user_id'],
            url: "http://vk.com/id#{hash['user_id']}",
            email: "#{hash['user_id']}@vk.com",
            nickname: nickname,
            access_token: hash['access_token']
          })
        else
          raise "Error"
        end
      end
  end

  class VkontakteMessage
    attr_accessor :user, :client
    def initialize(user)
      @user = user
    end

    def client
      @client ||= VkontakteApi::Client.new(user.access_token)
    end

    def send(message)
      message_text = message.text + ' ' + message.url
      response = client.wall.post(owner_id: user.uid, message: message_text)
      message.update_from(OpenStruct.new(access_token: nil, id: response.post_id))
      response
    end
  end

end
