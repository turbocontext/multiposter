class AddSettingsToUsers < ActiveRecord::Migration
  def up
    add_column :users, :settings, :hstore
    execute("CREATE INDEX users_settings ON users USING GIN(settings)")
  end

  def down
    remove_column :users, :settings
    execute("DROP INDEX users_setting")
  end
end
