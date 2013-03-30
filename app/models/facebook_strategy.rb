#-*- encoding: utf-8 -*-
require 'user_info'
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
      []
    end

    def create_pages
      user = FbGraph::User.me(@user.access_token)
      user.accounts.each do |account|
        next unless account.perms.include?("CREATE_CONTENT")
        users << SocialUser.create(
          provider: "facebook_#{account.category.downcase}",
          uid:      account.identifier,
          email:    "#{account.identifier}@facebook.com",
          nickname: account.name,
          access_token: account.access_token,
          expires: nil
        )
      end
      users
    end
  end
end
