class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.string :type
      t.float :amount
      t.string :status
      t.belongs_to :user
      t.belongs_to :bank
      t.timestamps
    end
  end
end
