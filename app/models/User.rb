class User < ActiveRecord::Base
    has_many :accounts

    def accounts
        Accounts.where("user_id = ?", self.id)
    end

    def open_accounts
        self.accounts.where("status = ?", "open")
    end

    def closed_accounts
        self.accounts.where("status IS NOT ?", "open")
    end

    def open_account_types
        self.open_accounts.map { |account| account.type }
    end

    def deposit(account, money)
        account.amount += money
        "You have successfully deposited ${money}. Congrats!"
    end

    def withdraw(account, money)
        account.amount -= money
        puts "You have withdrawn ${money}."
    end

    def open_an_account(type, amount, bank)
        if self.open_account_types.include?(type)
            puts "Can't open two accounts of the same kind"
        else
            Account.create(type: type, amount: amount, status: "open", user_id: self.id, bank_id: bank.id)
        end
    end

    def close_an_account(type)
        account_to_close = self.open_accounts.where("type = ?", type)
        account_to_close.close(self)
    end
  
end