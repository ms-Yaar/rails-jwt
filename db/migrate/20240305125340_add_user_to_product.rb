class AddUserToProduct < ActiveRecord::Migration[7.1]
  def change
    add_reference :products, :user, null: true, foreign_key: true
  end
end
