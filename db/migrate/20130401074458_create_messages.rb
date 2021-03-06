class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :short_text
      t.text :text
      t.text :url
      t.string :access_token
      t.string :uid
      t.string :status
      t.integer :social_user_id
      t.integer :message_set_id

      t.timestamps
    end
  end
end
