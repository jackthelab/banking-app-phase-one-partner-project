class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.string :type
      t.float :amount
      t.string :status
      t.timestamps
    end

    add_foreign_key :accounts, :users
    add_foreign_key :accounts, :banks
  end
end
