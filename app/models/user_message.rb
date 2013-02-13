class UserMessage < ActiveRecord::Base
  attr_accessible :user_id, :message_id

  belongs_to :user
  belongs_to :message
end
