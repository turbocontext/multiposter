class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :text
      t.string :access_token
      t.string :uid
      t.integer :social_user_id
      t.integer :message_set_id

      t.timestamps
    end
  end
end
