class Message < ActiveRecord::Base
  attr_accessible :access_token, :message_set_id,
                  :social_user_id, :text, :uid

  belongs_to :social_user
  belongs_to :message_set

  validates :text, presence: true
  # validates :message_set_id, presence: true
  validates :social_user_id, presence: true
  # validates :uid, presence: true
  # validates :access_token, presence: true

end
