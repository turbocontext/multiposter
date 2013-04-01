class MessageSet < ActiveRecord::Base
  attr_accessible :user_id

  belongs_to :user

  has_many :messages
  accepts_nested_attributes_for :messages

  validates :user_id, presence: true
end
