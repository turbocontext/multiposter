#-*- encoding: utf-8 -*-
class UserInfo
  class InsufficientInfoError < StandardError; end
  def initialize(auth)
    @auth = auth
    raise InsufficientInfoError unless valid?
    @uid          = auth[:uid]
    @nickname     = auth[:info][:nickname] || auth[:info][:name]
    @access_token = auth[:credentials][:token]
    @secret_token = auth[:credentials][:secret]
    @provider     = auth[:provider]
    @expires      = auth[:credentials][:expires]
  end
  attr_reader :uid, :access_token, :provider, :secret_token, :nickname,
              :expires, :expires_at, :auth

  def expires_at
    if time = auth[:credentials][:expires_at]
      @expires_at = Time.at(time.to_i)
    else
      @expires = false
      @expires_at = nil
    end
  end

  def url
    if auth[:info][:urls]
      auth[:info][:urls].each do |url|
        return url[1] if url[0] == provider.to_s.capitalize
      end
    end
  end

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
