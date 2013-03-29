#-*- encoding: utf-8 -*-
class SocialUser < ActiveRecord::Base

  belongs_to :user
  has_many :messages
  has_ancestry
  attr_accessible :email, :access_token,
                  :secret_token, :uid,
                  :provider, :user_id,
                  :nickname, :expires,
                  :parent_id

  validates_presence_of :access_token, :provider, :uid

  def self.from_omniauth(auth)
    provider = auth[:provider]
    user = "#{provider.to_s.camelize}::User".constantize.new(auth)
    main_user = create_with(user.main_user)
    user.subusers.each do |subuser|
      tmp = create_with(subuser)
      tmp.update_attributes(parent_id: main_user)
    end
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

end
