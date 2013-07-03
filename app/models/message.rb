class Message < ActiveRecord::Base
  attr_accessible :access_token, :message_set_id, :url, :uid,
                  :social_user_id, :text, :status, :short_text

  belongs_to :social_user
  belongs_to :message_set

  validates :text, presence: true
  # validates :message_set_id, presence: true
  validates :social_user_id, presence: true
  # validates :uid, presence: true
  # validates :access_token, presence: true

  after_create :send_message

  def send_message
    return false if Rails.env == 'test'
    provider = social_user.provider.to_s.camelize
    message = "#{provider}Strategy::#{provider}Message".constantize.new(social_user)
    message.send(self)
  end

  def delete_message
    return false if Rails.env == 'test'
    provider = social_user.provider.to_s.camelize
    message = "#{provider}Strategy::#{provider}Message".constantize.new(social_user)
    message.delete(self)
  end

  def update_from(response)
    uid = response.id
    access_token = response.access_token
    update_attributes(uid: uid, access_token: access_token)
  end
end
