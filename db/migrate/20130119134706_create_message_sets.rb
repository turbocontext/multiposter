class CreateMessageSets < ActiveRecord::Migration
  def change
    create_table :message_sets do |t|
      t.integer :user_id

      t.timestamps
    end
  end
end
