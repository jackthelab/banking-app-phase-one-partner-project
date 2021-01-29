class Bank < ActiveRecord::Base

    def accounts
        Accounts.where("bank_id = ?", self.id)
    end

    def open_accounts
        self.accounts.where("status = ?", "open")
    end

    def closed_accounts
        self.accounts.where("status IS NOT ?", "open")
    end

    def number_of_open_accounts
        self.open_accounts.count
    end

    def number_of_customers
        self.open_accounts.select { |account| account.user_id}.uniq.count
    end

    def total_value_of_all_accounts
        self.open_accounts.sum(:amount)
    end

    def see_accounts_above(num)
        self.open_accounts.where("amount > ?", num)
    end

    def close_account
        # some_account.close(self)
    end

end