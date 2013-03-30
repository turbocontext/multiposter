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
end
