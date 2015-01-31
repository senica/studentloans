# Student Loans

This is a boiler plate for the site https://moneyshare.us

My wife and I are asking for help to pay off our student loans. I wanted to post this up for others that might be raising money for a cause.

## Install
1. Clone the repository `git clone https://github.com/senica/studentloans.git`
2. Make sure you have [Sails JS](http://sailsjs.org/#/) installed
3. Make sure you have node and npm installed [http://nodejs.org/download/](http://nodejs.org/download/). Note that npm comes with node now.
4. Go to the directory that you cloned the repo to and run `npm install`. Note you may need to put `sudo` in front if your user does not have permissions.
5. Next, rename the file config/local.js.sample to config/local.js and fill it out. **DO NOT COMMIT THIS TO YOUR REPO** as this is where you will store your passwords to things like GMail and Stripe and your database.
6. Install [Postgres](http://www.postgresql.org/) and make sure it is running. If you are on Mac, this is what I use: [Postgres App](http://postgresapp.com/).
7. Create a database called `studentLoans` or configure your app accordingly.
8. Now run either `sails lift` or `sails console` to lift your site. The latter gives you a REPL for interacting with your backend while running... pretty cool.
9. Browser to `http://localhost:1337` to see your site.

a [Sails](http://sailsjs.org) application
