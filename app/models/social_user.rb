class SocialUser < ActiveRecord::Base

  belongs_to :user
  has_many :message_sets
  has_many :messages, through: :message_sets
  attr_accessible :email, :access_token, :secret_token, :uid, :provider, :user_id

  validates_presence_of :access_token, :provider

  def self.from_omniauth(auth)
    user_info = UserInfo.new(auth)
    if user = find_by_email_and_provider(user_info.email, user_info.provider)
      user.update_attributes(access_token: user_info.access_token)
    else
      create_with(user_info)
    end
  rescue InsufficientInfoError
    return nil
  end

  def self.create_with(info)
    create(
      provider: info.provider,
      uid:      info.uid,
      email:    info.email,
      access_token: info.access_token,
      secret_token: info.secret_token
    )
  end

end

class InsufficientInfoError < StandardError; end

class UserInfo
  def initialize(auth)
    @auth = auth
    raise InsufficientInfoError unless valid?
    @uid          = auth[:uid]
    @access_token = auth[:credentials][:token]
    @secret_token = auth[:credentials][:secret]
    @provider     = auth[:provider]
  end
  attr_reader :uid, :access_token, :provider, :secret_token

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
