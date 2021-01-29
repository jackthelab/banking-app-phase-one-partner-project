Banking App
____________
____________

** Overview **

1 -- Banking App is a CLI project to conclude Phase One of the Flatiron School Software Engineering program.

2 -- The goals were to build an app using OOP (in Ruby) principles while utilizing an ORM (ActiveRecord) while allowing users to interact outside of the terminal.

3 -- Areas which could have been and can still be improved (when time allows):

  a) Doing a better job of abstracting the bin/rub.rb file. However, it was prioritized last as the focus was on handling data through ActiveRecord which gave me more hangups than anticipated.
  b) I would like to abstract the deposit and withdraw activities on an account into instances of a single Activity class so banks and customers (of User class) can see the activity for each account.

    i. Can help with budget tracking
    ii. Can provide help with audits
    iii. Can be used for rewards programs, data analysis, and fraud/cyberattacking attempts

  c) I'd like to build in a password attempts counter which will only allow X number of attempts for a password.

____________

** Schema **

1 -- 3 Models

  a) Bank

    i. A bank instance can have many accounts but an account instance belongs to one bank instance
    ii. A bank instance can have many customers (user instances) through account instances

  b) User

    i. A user instance (customer) can have many accounts but an account instance belongs to one customer
    ii. A customer can have many bank instances through account instances

  c) Account

    i. An account instance belongs to one bank instance
    ii. An account instance belongs to one customer

____________

** User Stories ** 

1 -- Both

  a) Both banks and customers should be able to login or sign up and be taken to respective action menus.
  b) Should be able to logout -- which ends the program and requires a refresh and new login.

    i. Logging out is the only way to end the program after a successful login (minus a control/command + C ) to help make sure banks and users do not leave profile open and accessible.

2 -- Bank

  a) See the number of open accounts at this bank instance
  b) See the number of customers at this bank instance
  c) See the total value of all all open accounts at this bank instance
  d) See all open accounts with a balance over $10,000 at this bank instance
  e) A bank should be able to close an account at this bank instance

3 -- Customer

  a) See their accounts - account type, status, and amount
  b) Make a deposit
  c) Make a withdraw
  d) Open an account if they do not already have an account which is the same account_type
  e) Close an account which they have.

____________