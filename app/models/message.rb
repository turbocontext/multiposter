class Message < ActiveRecord::Base
  attr_accessible :message_set_id, :social_user_id, :text

  belongs_to :social_user
  belongs_to :message_set

  validates_presence_of :social_user_id, :text, :message_set_id
end
