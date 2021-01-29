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
    new_password = create_password.mask("Please create a password: ", required: true)

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
    entered_password = ask_for_password.ask("What is your password? ", required: true)

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

if current_profile.class == Bank
    # puts "Current profile needs bank operations page"
    choose_operaton = TTY::Prompt.new
    command = choose_operaton.select("What would you like to do?", ["See number of open accounts", "See number of current customers", "See total value of all accounts", "See Accounts above $10,000", "Close Account"])
    puts "#{current_profile.username} would like to #{command}"
else
    # puts "Current profile nees user operations page"
    choose_operaton = TTY::Prompt.new
    command = choose_operaton.select("What would you like to do?", ["See accounts", "Make a deposit", "Make a withdraw", "Open Account", "Close Account"])
    puts "#{current_profile.username} would like to #{command}"
end

# binding.pry
# puts "Thanks for trusting us."