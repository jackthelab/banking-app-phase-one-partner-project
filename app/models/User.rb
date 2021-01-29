class User < ActiveRecord::Base
    has_many :accounts
    has_many :banks, through: :accounts

    def all_accounts
        Account.where("user_id = ?", self.id)
    end

    def open_accounts
        self.all_accounts.where("status = ?", "open")
    end

    def closed_accounts
        self.all_accounts.where("status IS NOT ?", "open")
    end

    def open_account_types
        self.open_accounts.map { |account| account.account_type }
    end

    def deposit(account, money)
        account.amount += money
        account.update(amount: account.amount)
        puts "You have successfully deposited $#{money}. Congrats!"
    end

    def withdraw(account, money)
        account.amount -= money
        account.update(amount: account.amount)
        puts "You have withdrawn $#{money}."
    end

    def open_an_account(account_type, amount, bank)
        if self.open_account_types.include?(account_type)
            puts "Can't open two accounts of the same kind"
        else
            Account.create(account_type: account_type, amount: amount, status: "open", user_id: self.id, bank_id: bank.id)
            puts "You have successfully opened a #{account_type} account. Congrats!"
        end
    end

    def close_an_account(account_type)
        account_to_close = self.open_accounts.where("account_type = ?", account_type)[0]
        account_to_close.close(self)
        puts "You have successfully closed your #{account_type} account."
    end
  
end