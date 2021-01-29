class Account < ActiveRecord::Base
    belongs_to :user
    belongs_to :bank

    def close(party)
        self.status = "closed by #{party.class}: #{party.username}"
    end

end