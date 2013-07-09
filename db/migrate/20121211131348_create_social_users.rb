class CreateSocialUsers < ActiveRecord::Migration
  def change
    create_table :social_users do |t|
      t.string  :uid
      t.string  :provider
      t.string  :access_token
      t.string  :secret_token
      t.string  :nickname
      t.string  :ancestry
      t.boolean :expires
      t.date    :expires_at
      t.string  :url
      t.integer :user_id
      t.string  :email
      t.boolean :checked, default: true, nil: false

      t.timestamps
    end
    add_index :social_users, :user_id
    add_index :social_users, :uid
  end
end
