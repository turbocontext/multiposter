#-*- encoding: utf-8 -*-
require "ostruct"
module TestProviderStrategy
  class User
    def initialize(auth)
    end

    def main_user
      OpenStruct.new({
        provider: 'test_provider',
        uid: "100003700047553",
        nickname: "test_user",
        access_token: "access_token",
        secret_token: "secret_token",
        user_id: "12",
        email: "email@email.com"
      })
    end

    def subusers
      [
        OpenStruct.new({
          provider: 'test_provider',
          uid: "100003700047553",
          nickname: "test_community",
          access_token: "access_token",
          secret_token: "secret_token",
          user_id: "12",
          email: "email@email.com"
        }),
        OpenStruct.new({
          provider: 'test_provider',
          uid: "100003700047553",
          nickname: "test_community",
          access_token: "access_token",
          secret_token: "secret_token",
          user_id: "12",
          email: "email@email.com"
        })
      ]
    end
  end
end
