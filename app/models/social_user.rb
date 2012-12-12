class SocialUser < ActiveRecord::Base
  belongs_to :user
  attr_accessible :email, :access_token, :uid, :provider, :user_id

  def self.from_omniauth(auth, current_user)
    where(auth.slice(:provider, :uid)).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.access_token = auth.credentials.token
      user.user_id = current_user.id
      if ["twitter"].include?(auth.provider) and auth.info.email.nil?
        user.email = "#{auth.info.nickname}@#{auth.provider}.com"
      end
    end
  end

end
