class Message < ActiveRecord::Base
  attr_accessible :access_token, :message_set_id,
                  :social_user_id, :text, :uid, :url

  belongs_to :social_user
  belongs_to :message_set

  validates :text, presence: true
  # validates :message_set_id, presence: true
  validates :social_user_id, presence: true
  # validates :uid, presence: true
  # validates :access_token, presence: true

  after_create :send_message

  def send_message

  end


  def update_from(response)
    uid = response.identifier || response.id
    access_token = response.access_token
    update_attributes(uid: uid, access_token: access_token)
  end
end
