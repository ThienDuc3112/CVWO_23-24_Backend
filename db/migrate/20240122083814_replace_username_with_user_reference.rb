class ReplaceUsernameWithUserReference < ActiveRecord::Migration[7.1]
  def change
    remove_column :threds, :username
    remove_column :followups, :username

    add_reference :threds, :user, foreign_key: true
    add_reference :followups, :user, foreign_key: true
  end
end
