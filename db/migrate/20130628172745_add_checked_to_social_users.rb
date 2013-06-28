class AddCheckedToSocialUsers < ActiveRecord::Migration
  def change
    add_column :social_users, :checked, :boolean, default: true, nill: false
  end
end
