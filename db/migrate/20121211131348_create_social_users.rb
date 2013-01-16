class CreateSocialUsers < ActiveRecord::Migration
  def change
    create_table :social_users do |t|
      t.string  :uid
      t.string  :provider
      t.string  :access_token
      t.string  :secret_token
      t.integer :user_id
      t.string  :email
    end
  end
end
