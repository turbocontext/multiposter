#-*- encoding: utf-8 -*-
require 'user_info'
require "ostruct"
module FacebookStrategy
  class User
    def initialize(auth)
      @auth = auth
      @info = UserInfo.new(auth)
    end

    def main_user
      @info
    end

    def subusers
      user = FbGraph::User.me(@info.access_token)
      user.accounts.inject([]) do |result, account|
        if account.perms.include?("CREATE_CONTENT")
          result << OpenStruct.new(
            provider: "facebook_#{account.category.downcase}",
            uid:      account.identifier,
            email:    "#{account.identifier}@facebook.com",
            nickname: account.name,
            access_token: account.access_token
          )
        else
          result
        end
      end
    end
  end
end
