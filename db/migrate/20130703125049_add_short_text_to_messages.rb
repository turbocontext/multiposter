class AddShortTextToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :short_text, :text
  end
end
