class Message < ActiveRecord::Base
  attr_accessible :social_user_id, :user_message_id, :text

  belongs_to :social_user
  belongs_to :message_set

  validates_presence_of :social_user_id, :user_message_id, :text
end
