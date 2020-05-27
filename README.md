# README

## What is Usertopia?
This project is meant to be a launching point for a new Rails application
that has users - and let's face it, any serious application will have
users that need to login with various access rights. In addition, most
application require basic formatting and you do want to do tests, right?

## The Quick Start

1. Create a new RVM gemset for the project.
    1. \> rvm gemset create ruby-2.X.X@app-name 
1. Clone the repository.
1. cd into the new repository.
1. Delete the .git file in the root directory.
1. Update .ruby-version to use the new gemset.
1. cd out of the repository & then back in. List gemsets to make sure
you're using the right one.
1. Install the latest bundler (gem install bundler).
1. Do a bundle install. 
1. Run yarn (yarn install --check-files).
1. Create the new Postgres databases to use.
1. Update the database.yml file to point at the new databases.
1. Run rake db:migrate.
1. Run the rails server in a terminal window (rails server -p 3001).
1. Make sure the new site loads in a browser (http://0.0.0.0:3001).
1. Run spec tests.
1. Create a new repository from this updated source.

## Some Project Details
This project uses the following components:
1. Database: Postgres
1. Authentication: bcrypt & has_secure_password
1. Authorization: Pundit & enumerize (for setting roles)
1. Testing: Rspec
1. Visual Formatting: Bootstrap 3 + Octicons