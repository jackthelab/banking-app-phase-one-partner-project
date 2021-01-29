class Account < ActiveRecord::Base

    def close(party)
        self.status = "closed by #{party.class}: #{party.username}"
    end

end