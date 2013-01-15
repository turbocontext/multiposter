class SocialUser < ActiveRecord::Base
  belongs_to :user
  attr_accessible :email, :access_token, :uid, :provider, :user_id

  def self.from_omniauth(auth, current_user)
    user_info = UserInfo.new(auth)
    if user = find_by_email_and_provider(user_info.email, user_info.provider)
      user.update_attributes(access_token: user_info.access_token)
    else
      create_with(user_info, current_user)
    end
  end

  def self.create_with(info, current_user)
    create(
      provider: info.provider,
      uid:      info.uid,
      email:    info.email,
      user_id:  current_user.id,
      access_token: info.access_token
    )
  end

end

class UserInfo
  def initialize(auth)
    @auth = auth
    @uid          = auth.uid
    @access_token = auth.credentials.token
    @provider     = auth.provider
  end
  attr_reader :uid, :access_token, :provider

  def email
    if @auth.info.email.nil?
      "#{@auth.info.nickname}@#{@auth.provider}.com"
    else
      @auth.info.email
    end
  end
end
