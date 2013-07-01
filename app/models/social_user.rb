#-*- encoding: utf-8 -*-
class SocialUser < ActiveRecord::Base

  belongs_to :user
  has_many :messages, dependent: :destroy
  has_ancestry
  attr_accessible :email, :access_token, :secret_token, :uid, :provider,
                  :user_id, :nickname, :parent_id, :expires, :expires_at,
                  :url, :checked

  attr_accessor :auth_string

  validates_presence_of :access_token, :provider, :uid

  def self.from_omniauth(auth)
    provider = auth[:provider]
    user = "#{provider.to_s.camelize}Strategy::User".constantize.new(auth)
    main_user = create_with(user.main_user)
    subusers = user.subusers.inject([]) do |result, subuser|
      tmp = create_with(subuser)
      tmp.update_attributes(parent_id: main_user)
      result << tmp
    end
    [main_user].concat(subusers)
  end

  def self.create_with(info)
    create!(
      provider: info.provider,
      uid:      info.uid,
      url:      info.url,
      email:    info.email,
      nickname: info.nickname,
      expires:  info.expires,
      expires_at:   info.expires_at,
      access_token: info.access_token,
      secret_token: info.secret_token
    )
  end

  def clone_from(social_user)
    social_user.children.each do |user|
      user.update_attributes(parent_id: self.id)
    end
    attributes = social_user.attributes
    attributes.delete("id")
    attributes.delete("ancestry")
    attributes.delete("user_id")
    update_attributes(attributes)
  end

end
