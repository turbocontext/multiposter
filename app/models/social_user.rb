#-*- encoding: utf-8 -*-
class SocialUser < ActiveRecord::Base

  belongs_to :user
  has_many :messages
  has_ancestry
  attr_accessible :email, :access_token, :secret_token, :uid, :provider, :user_id, :nickname, :expires
  after_create :call_after_create_strategy

  validates_presence_of :access_token, :provider

  def call_after_create_strategy
    if SocialUser.providers.include?(self.provider)
      strategy = "#{provider.to_s.camelize}::AfterCreateStrategy".constantize.new(user: self)
      strategy.process
    end
  end

  def self.from_omniauth(user_info)
    if user = find_by_uid(user_info.uid)
      user.update_attributes(access_token: user_info.access_token)
    else
      create_with(user_info)
    end
  rescue UserInfo::InsufficientInfoError
    return nil
  end

  def self.create_with(info)
    create(
      provider: info.provider,
      uid:      info.uid,
      email:    info.email,
      nickname: info.nickname,
      access_token: info.access_token,
      secret_token: info.secret_token,
      expires:  info.expires
    )
  end

  def self.providers
    [:facebook, :twitter]
  end

end
