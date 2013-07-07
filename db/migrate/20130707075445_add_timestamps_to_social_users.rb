class AddTimestampsToSocialUsers < ActiveRecord::Migration
  def change
    change_table :social_users do |t|
      t.timestamps
    end
  end
end
