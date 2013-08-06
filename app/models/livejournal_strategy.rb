#-*- encoding: utf-8 -*-
require 'user_info'
require "ostruct"
require 'livejournal'
module LivejournalStrategy
  class User
    attr_accessor :auth, :info
    def initialize(auth)
      @auth = auth
    end

    def main_user
      return OpenStruct.new({
        provider: 'livejournal',
        uid: @auth[:uid],
        url: "http://#{@auth[:uid]}.livejournal.com",
        email: "#{@auth[:uid]}@livejournal.com",
        nickname: @auth[:uid],
        access_token: @auth[:access_token]
      })
    end

    def subusers
      []
    end
  end

  class LivejournalMessage
    attr_accessor :user
    def initialize(user)
      @user = user
    end

    def send(message)
      lj_user = LiveJournal::User.new(user.uid, user.access_token)
      login = LiveJournal::Request::Login.new(lj_user)
      login.run

      entry = LiveJournal::Entry.new
      entry.subject = message.short_text
      entry.event = message.text + '<br>' + message.url

      post = LiveJournal::Request::PostEvent.new(lj_user, entry)
      post.run
    end

    def delete(message)
      true
    end
  end

end
