require_relative '../config/environment'
require 'tty-prompt'

# Prompt -- user/bank?
entity_type = TTY::Prompt.new
entity_type.select("Hi! First tell us who you are:", ["A Bank", "An Individual"])

# Prompt -- login/signup?
login_or_signup = TTY::Prompt.new
login_or_signup.select("Great! Are you returning or new to the platform?", ["Login", "Sign Up"])

current_profile = nil

# If logging in
if login_or_signup == "Login"
    # puts "What is your username? "
    # username = gets.chomp
    username = nil
    username_valid = false
    while username_valid == false
        print "What is your username? "
        username = gets.chomp
        
        if User.find_by(username: username)
            username_valid = true
            return username
        else
            puts "Sorry. Invalid username. Please try again"
        end
    end

    # username.ask("What is your username? ", required: true) do |q|
    #     q.validate(/\A[^.]+\.[^.]+\Z/)
    # end

    password = nil
    password_valid = false
    password_attempts = 0
    while password_valid == false && password_attempts < 5
        print "What is your password? "
        password = gets.chomp

        password_to_check = User.find_by(username: username).password
        if password == password_to_check
            password_valid = true
            return password
        else
            password_attempts += 1
            puts "That's the wrong password. You have #{5 - password_attempts} attempts left."
        end
    end

    if username_valid && password_valid
        #
    end

    # password = TTY::Prompt.new
    # password.ask("What is your password? ", required:true) do |q|
    #     q.validate(/\A.{6,}+\Z/)
    # end

    # as a bank
    if entity_type == "A Bank"
        # login for bank
        # make bank with username == username the current profile
        ## else re enter username
        ## if password == password
        ## else try logging in again
        ## 5 attempts?? Message "Please contact support (Didn't have time to actually buid lock out though)"
        # current_profile = ...
    
    # as a user
    else
        # login for user
        # see similar process for above
        # current_profile = ...
    end

#if signing up for account
else
    name = TTY::Prompt.new
    name.ask("Enter your full name: ", required: true)
    
    # username format user.name
    username = TTY::Prompt.new
    username.ask("Choose a username. Required Format = user.name: ", required: true) do |q|
        q.validate(/\A[^.]+\.[^.]+\Z/)
    end

    #password which is more than 6 characters
    password = TTY::Prompt.new
    password.ask("Choose your password. Must use 6 or more characters: ", required:true) do |q|
        q.validate(/\A.{6,}\Z/)
    end

    #specifics for account if a bank
    if entity_type == "A Bank"
        city = TTY::Prompt.new
        city.ask("Where is your bank located? ", required: true)
        city = city.capitalize

        # phone_number format: ###-###-####
        phone_number = TTY::Prompt.new
        phone_number.ask("Enter a phone number with a ###-###-#### format: ", required: true) do |q|
            q.validate(/\A[0-9]{3}+\-[0-9]{3}+\-[0-9]{4}\Z/)
        end

        website_url = TTY::Prompt.new
        website_url.ask("What is your bank's website_url? ", required: true)

        # make new Bank instance but don't save
        new_bank = Bank.new(name: name, username: username, password: password, city: city, phone_number: phone_number, website_url: website_url)
        if Bank.find_by(username: new_bank.username)
            puts "We couldn't register you because it looks like your username already exist.
            Please refresh and try logging in instead.
            If you don't have an account please refresh and try a different username."
        else
            new_bank.save
        end

    else
        # validates email form
        email = TTY::Prompt.new
        email.ask("Enter a valid email: ", required: true) do |q|
            q.validate(/\A.+\@[^.]+\.[^.]{3}+\Z/)
        end

        # create new user if the username doesn't already exist but rejects if username in database
        new_user = User.new(name: name, username: username, password: password, email: email)
        if User.find_by(username: new_user.username)
            puts "We couldn't register you because it looks like your username already exist.
            Please refresh and try logging in instead.
            If you don't have an account please refresh and try a different username."
        else
            new_user.save
        end
    end
end




# Prompt -- login/signup?
binding.pry
puts "Thanks for trusting us."


