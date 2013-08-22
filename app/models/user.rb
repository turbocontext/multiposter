# --- encoding: utf-8 ---
require "hstore_methods"
class User < ActiveRecord::Base
  store_accessor :settings, :language

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  before_create :generate_api_key

  has_many :social_users, dependent: :destroy
  has_many :messages, through: :social_users

  has_many :message_sets

  def social(net)
    social_users.where(provider: net)
  end

  private

  def generate_api_key
    begin
      self.api_key = SecureRandom.hex
    end while self.class.exists?(api_key: api_key)
  end

end
