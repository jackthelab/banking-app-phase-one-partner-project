class AddBankidToAccounts < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :bank_id, :integer
    add_foreign_key :accounts, :banks
  end
end
