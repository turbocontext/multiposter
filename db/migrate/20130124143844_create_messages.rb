class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :text
      t.integer :social_user_id
      t.integer :user_message_id

      t.timestamps
    end
  end
end
