require_relative '../config/environment'
require 'tty-prompt'
# binding.pry
# Prompt -- user/bank?
entity_type_prompt = TTY::Prompt.new
entity_type = entity_type_prompt.select("Hi! First tell us who you are:", ["A Bank", "An Individual"])

# Prompt -- login/signup?
login_signup_prompt = TTY::Prompt.new
login_signup_choice = login_signup_prompt.select("Great! Are you returning or new to the platform?", ["Login", "Sign Up"])

current_profile = nil

if login_signup_choice == "Sign Up"

    create_name = TTY::Prompt.new
    new_name = create_name.ask("Please provide your full name: ", required: true)

    create_username = TTY::Prompt.new
    new_username = create_username.ask("Please choose a username: ", required: true)

    create_password = TTY::Prompt.new
    new_password = create_password.ask("Please create a password (min. 8 characters): ", required: true) do |t|
        t.validate(/\A.{8,}\Z/)
    end

    if entity_type == "A Bank"
        if !Bank.find_by(username: new_username)
            Bank.create(name: new_name, username: new_username, password: new_password)
            current_profile = Bank.find_by(username: new_username)
        else
            puts "It looks like that username already exists. Please restart and try logging in, if you have an account, or choose a different username."
        end
    else
        if !User.find_by(username: new_username)
            User.create(name: new_name, username: new_username, password: new_password)
            current_profile = User.find_by(username: new_username)
        else
            puts "It looks like that username already exists. Please restart and try logging in, if you have an account, or choose a different username."
        end
    end
else
    ask_for_username = TTY::Prompt.new
    entered_username = ask_for_username.ask("What is your username? ", required: true)

    ask_for_password = TTY::Prompt.new
    entered_password = ask_for_password.mask("What is your password? ", required: true)

    if entity_type == "A Bank"
        if Bank.find_by(username: entered_username) && Bank.find_by(username: entered_username).password == entered_password
            current_profile = Bank.find_by(username: entered_username)
        elsif Bank.find_by(username: entered_username)
            puts "Sorry. That's the incorrect password. Please restart and try again."
        else
            puts "Sorry. We don't have any record of that user name. If you don't have an account try restarting and signing up."
        end
    else
        if User.find_by(username: entered_username) && User.find_by(username: entered_username).password == entered_password
            current_profile = User.find_by(username: entered_username)
        elsif User.find_by(username: entered_username)
            puts "Sorry. That's the incorrect password. Please restart and try again."
        else
            puts "Sorry. We don't have any record of that user name. If you don't have an account try restarting and signing up."
        end
    end
end

done = false

while done == false && current_profile != nil

    if current_profile.class == Bank
        choose_operaton = TTY::Prompt.new
        command = choose_operaton.select("What would you like to do?", ["See number of open accounts", "See number of customers", "See total value of open accounts", "See accounts above $10,000", "Close Account", "Logout"])
        # puts "#{current_profile.username} would like to #{command}"
        case command
        when "See number of open accounts"
            puts "Number of Accounts: #{current_profile.number_of_open_accounts}"
        when "See number of customers"
            puts "Number of Customers: #{current_profile.number_of_customers}"
        when "See total value of open accounts"
            puts "All Money in Open Accounts: $#{current_profile.total_value_of_open_accounts}"
        when "See accounts above $10,000"
            if current_profile.see_accounts_above(10000).count > 0
                current_profile.see_accounts_above(10000).each do |account|
                    puts "-----------"
                    puts "Account type: #{account.account_type}"
                    puts "Account amount: #{account.amount}"
                    puts "-----------"
                end
            else
                puts "It doesn't look like you have any accounts over $10,000 right now."
            end
        when "Close Account"
            get_user_profile = TTY::Prompt.new
            customer_username = get_user_profile.ask("What is the username for the customer on the account?", required: true)
            customer = User.find_by(username: customer_username)
            get_account_type = TTY::Prompt.new
            account_type = get_account_type.select("Which account would you like to close?", customer.open_account_types)

            current_profile.close_account(customer, account_type)
            puts "You've successfully closed the #{account_type} account for #{customer.username}."
        else
            done = true
        end
    else
        choose_operaton = TTY::Prompt.new
        command = choose_operaton.select("What would you like to do?", ["See accounts", "Make a deposit", "Make a withdraw", "Open Account", "Close Account", "Logout"])
        # puts "#{current_profile.username} would like to #{command}"
        case command
        when "See accounts"
            if current_profile.all_accounts.count > 0
                current_profile.all_accounts.each do |account|
                    puts "-----------"
                    puts "Type: #{account.account_type}"
                    puts "Status: #{account.status}"
                    puts "Amount: #{account.amount}"
                    puts "-----------"
                end
            else
                puts "It looks like you don't have any accounts yet. You can open an account though."
            end
        when "Make a deposit"
            choose_account = TTY::Prompt.new
            account_type = choose_account.select("Which of your accounts would you like to deposit to?", current_profile.open_account_types)
            account = Account.where("user_id = ? AND account_type = ?", current_profile.id, account_type)[0]
            choose_amount = TTY::Prompt.new
            money = choose_amount.ask("How much would you like to deposit? Use only numbers!", required: true) do |q|
                q.validate(/\A[0-9]+[0-9]\Z/)
            end
            money = money.to_f
            current_profile.deposit(account, money)
        when "Make a withdraw"
            choose_account = TTY::Prompt.new
            account_type = choose_account.select("Which of your accounts would you like to withdraw from?", current_profile.open_account_types)
            account = Account.where("user_id = ? AND account_type = ?", current_profile.id, account_type)[0]
            choose_amount = TTY::Prompt.new
            money = choose_amount.ask("How much would you like to withdraw? Use only numbers!", required: true) do |q|
                q.validate(/\A[0-9]+[0-9]\Z/)
            end
            money = money.to_f
            current_profile.withdraw(account, money)
        when "Open Account"
            choose_account_type = TTY::Prompt.new
            account_type = choose_account_type.select("What kind of account would you like to open?", ["Checking", "Savings"])
            choose_amount = TTY::Prompt.new
            amount = choose_amount.ask("How much would you like open the account with? Use only numbers!", required: true) do |q|
                q.validate(/\A[0-9]+[0-9]\Z/)
            end
            amount = amount.to_f
            choose_bank = TTY::Prompt.new
            bank_username = choose_bank.ask("What is your bank's username?", required: true)
            bank = Bank.find_by(username: bank_username)

            current_profile.open_an_account(account_type, amount, bank)
        when "Close Account"
            if current_profile.open_accounts.count > 0
                choose_account_type = TTY::Prompt.new
                account_type = choose_account_type.select("Which account would you like to close?", current_profile.open_account_types)
                current_profile.close_an_account(account_type)
            else
                puts "It doesn't appear you have any open accounts at the moment."
            end
        else
            done = true
        end
    end

end

# binding.pry
puts "Thanks for trusting us."