#-*- encoding: utf-8 -*-

class UserInfo
  class InsufficientInfoError < StandardError; end
  def initialize(auth)
    @auth = auth
    raise InsufficientInfoError unless valid?
    @uid          = auth[:uid]
    @nickname     = auth[:info][:nickname]
    @access_token = auth[:credentials][:token]
    @secret_token = auth[:credentials][:secret]
    @provider     = auth[:provider]
    @expires      = auth[:credentials][:expires]
  end
  attr_reader :uid, :access_token, :provider, :secret_token, :nickname, :expires

  def email
    if @auth[:info][:email].nil?
      "#{@auth[:info][:nickname]}@#{@auth[:provider]}.com"
    else
      @auth[:info][:email]
    end
  end

  def valid?
    @auth && @auth[:uid] && @auth[:credentials] && @auth[:credentials][:token] && @auth[:provider]
  end
end
