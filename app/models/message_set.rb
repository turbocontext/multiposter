class MessageSet < ActiveRecord::Base
  attr_accessible :user_id, :messages_attributes

  belongs_to :user

  has_many :messages
  accepts_nested_attributes_for :messages, reject_if: lambda { |s| s[:text].blank? }

  validates :user_id, presence: true
end
